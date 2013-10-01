Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63220 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3JATky (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 15:40:54 -0400
Received: by mail-ie0-f170.google.com with SMTP id x13so15198613ief.1
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 12:40:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131001173416.GF27490@localhost.localdomain>
References: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
 <20130929004252.GL18681@localhost.localdomain> <CAEx9m440QMtfkaZjc5Qgu6jv+TsejheKG5nVuYhAEe_vqgp0MQ@mail.gmail.com>
 <20130929131224.GM18681@localhost.localdomain> <CAEx9m47a_kXvsmOOvSud8ERycB-5D04Nu0ZTHgYzP8RtawBYgg@mail.gmail.com>
 <20130930201125.GA27490@localhost.localdomain> <CAEx9m47DFKxUQP6k6qdei1FpPe17hyGGGxZNbANZPiK9qrKoxw@mail.gmail.com>
 <20130930204738.GB27490@localhost.localdomain> <CAEx9m46QXYSHjCAF3enUom__SwR8vDNsw_qmzFqXZPnPwxF_1w@mail.gmail.com>
 <20131001173416.GF27490@localhost.localdomain>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Tue, 1 Oct 2013 21:40:33 +0200
Message-ID: <CAEx9m47fk2zwpAdPq2gFx1Y5DDV9rqtWzo=QxmCUgeTS83fBOQ@mail.gmail.com>
Subject: Re: Questions regarding logging upon fsync in btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e01183c5c7e9e9404e7b32149
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--089e01183c5c7e9e9404e7b32149
Content-Type: text/plain; charset=ISO-8859-1

On 1 October 2013 19:34, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Sep 30, 2013 at 11:07:20PM +0200, Aastha Mehta wrote:
>> On 30 September 2013 22:47, Josef Bacik <jbacik@fusionio.com> wrote:
>> > On Mon, Sep 30, 2013 at 10:30:59PM +0200, Aastha Mehta wrote:
>> >> On 30 September 2013 22:11, Josef Bacik <jbacik@fusionio.com> wrote:
>> >> > On Mon, Sep 30, 2013 at 09:32:54PM +0200, Aastha Mehta wrote:
>> >> >> On 29 September 2013 15:12, Josef Bacik <jbacik@fusionio.com> wrote:
>> >> >> > On Sun, Sep 29, 2013 at 11:22:36AM +0200, Aastha Mehta wrote:
>> >> >> >> Thank you very much for the reply. That clarifies a lot of things.
>> >> >> >>
>> >> >> >> I was trying a small test case that opens a file, writes a block of
>> >> >> >> data, calls fsync and then closes the file. If I understand correctly,
>> >> >> >> fsync would return only after all in-memory buffers have been
>> >> >> >> committed to disk. I have added few print statements in the
>> >> >> >> __extent_writepage function, and I notice that the function gets
>> >> >> >> called a bit later after fsync returns. It seems that I am not
>> >> >> >> guaranteed to see the data going to disk by the time fsync returns.
>> >> >> >>
>> >> >> >> Am I doing something wrong, or am I looking at the wrong place for
>> >> >> >> disk write? This happens both with tree logging enabled as well as
>> >> >> >> with notreelog.
>> >> >> >>
>> >> >> >
>> >> >> > So 3.1 was a long time ago and to be sure it had issues I don't think it was
>> >> >> > _that_ broken.  You are probably better off instrumenting a recent kernel, 3.11
>> >> >> > or just build btrfs-next from git.  But if I were to make a guess I'd say that
>> >> >> > __extent_writepage was how both data and metadata was written out at the time (I
>> >> >> > don't think I changed it until 3.2 or something later) so what you are likely
>> >> >> > seeing is the normal transaction commit after the fsync.  In the case of
>> >> >> > notreelog we are likely starting another transaction and you are seeing that
>> >> >> > commit (at the time the transaction kthread would start a transaction even if
>> >> >> > none had been started yet.)  Thanks,
>> >> >> >
>> >> >> > Josef
>> >> >>
>> >> >> Is there any special handling for very small file write, less than 4K? As
>> >> >> I understand there is an optimization to inline the first extent in a file if
>> >> >> it is smaller than 4K, does it affect the writeback on fsync as well? I did
>> >> >> set the max_inline mount option to 0, but even then it seems there is
>> >> >> some difference in fsync behaviour for writing first extent of less than 4K
>> >> >> size and writing 4K or more.
>> >> >>
>> >> >
>> >> > Yeah if the file is an inline extent then it will be copied into the log
>> >> > directly and the log will be written out, no going through the data write path
>> >> > at all.  Max inline == 0 should make it so we don't inline, so if it isn't
>> >> > honoring that then that may be a bug.  Thanks,
>> >> >
>> >> > Josef
>> >>
>> >> I tried it on 3.12-rc2 release, and it seems there is a bug then.
>> >> Please find attached logs to confirm.
>> >> Also, probably on the older release.
>> >>
>> >
>> > Oooh ok I understand, you have your printk's in the wrong place ;).
>> > do_writepages doesn't necessarily mean you are writing something.  If you want
>> > to see if stuff got written to the disk I'd put a printk at run_delalloc_range
>> > and have it spit out the range it is writing out since thats what we think is
>> > actually dirty.  Thanks,
>> >
>> > Josef
>>
>> No, but I also placed dump_stack() in the beginning of
>> __extent_writepage. run_delalloc_range is being called only from
>> __extent_writepage, if it were to be called, the dump_stack() at the
>> top of __extent_writepage would have printed as well, no?
>>
>
> Ok I've done the same thing and I'm not seeing what you are seeing.  Are you
> using any mount options other than notreelog and max_inline=0?  Could you adjust
> your printk to print out the root objectid for the inode as well?  It could be
> possible that this is the writeout for the space cache or inode cache.  Thanks,
>
> Josef

I actually printed the stack only when the root objectid is 5. I have
attached another log for writing the first 500 bytes in a file. I also
print the root objectid for the inode in run_delalloc and
__extent_writepage.

Thanks

-- 
Aastha Mehta
MPI-SWS, Germany
E-mail: aasthakm@mpi-sws.org

--089e01183c5c7e9e9404e7b32149
Content-Type: text/plain; charset=US-ASCII; name="fsync-3.12-rc2-500bytes-011013.txt"
Content-Disposition: attachment;
	filename="fsync-3.12-rc2-500bytes-011013.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm9j6u2k0

d3JpdGUgc3VjY2Vzcywgc2l6ZTogNTAwCmZzeW5jOjogU3VjY2VzcwpmaWxlIHNpemU6IDUwMApm
Y2xvc2U6OiBTdWNjZXNzCgoKWyAgODI5Ljg0NzQ4M10gYnRyZnM6IGRldmljZSBmc2lkIDRkMjc2
N2VhLTg1Y2MtNDQzYy04OGJkLTJkOGM2OTNmN2M3YyBkZXZpZCAxIHRyYW5zaWQgMjIwMSAvZGV2
L3NkZApbICA4MjkuODQ4MTk5XSBidHJmczogbWF4X2lubGluZSBhdCAwClsgIDgyOS44NDgyMDFd
IGJ0cmZzOiBkaXNhYmxpbmcgdHJlZSBsb2cKWyAgODI5Ljg0ODIwMl0gYnRyZnM6IGRpc2sgc3Bh
Y2UgY2FjaGluZyBpcyBlbmFibGVkClsgIDgzNS4yNjY0ODNdIFtkb193cml0ZXBhZ2VzXSBpbnVt
OiAyNTgsIG5yX3RvX3dyaXRlOiA5MjIzMzcyMDM2ODU0Nzc1ODA3LCB3cml0ZXBhZ2VzIGZuOiBm
ZmZmZmZmZjgxMjljZTQwClsgIDgzNS4yNjY0OTJdIENQVTogMCBQSUQ6IDEwMDIxIENvbW06IGJi
IE5vdCB0YWludGVkIDMuMTIuMC1yYzItbGF0ZXN0KyAjNwpbICA4MzUuMjY2NDk0XSBIYXJkd2Fy
ZSBuYW1lOiBpbm5vdGVrIEdtYkggVmlydHVhbEJveCwgQklPUyBWaXJ0dWFsQm94IDEyLzAxLzIw
MDYKWyAgODM1LjI2NjQ5Nl0gIGZmZmY4ODAwM2NkYzVlNjAgZmZmZjg4MDAzY2RjNWUyOCBmZmZm
ZmZmZjgxN2E4YWNmIGZmZmY4ODAwM2ZjMGViNDgKWyAgODM1LjI2NjUxMV0gIGZmZmY4ODAwMWY0
NzhiMjggZmZmZjg4MDAzY2RjNWU0OCBmZmZmZmZmZjgxMTA1YzFmIGZmZmY4ODAwMWY0Nzg5ZTAK
WyAgODM1LjI2NjUxNV0gIGZmZmY4ODAwMzc1NTc0MDAgZmZmZjg4MDAzY2RjNWU4OCBmZmZmZmZm
ZjgxMGZiNjg5IGZmZmY4ODAwM2ZjMTJjMDAKWyAgODM1LjI2NjUxOF0gQ2FsbCBUcmFjZToKWyAg
ODM1LjI2NjUyOF0gIFs8ZmZmZmZmZmY4MTdhOGFjZj5dIGR1bXBfc3RhY2srMHg0Ni8weDU4Clsg
IDgzNS4yNjY1MzRdICBbPGZmZmZmZmZmODExMDVjMWY+XSBkb193cml0ZXBhZ2VzKzB4NGYvMHg5
MApbICA4MzUuMjY2NTM4XSAgWzxmZmZmZmZmZjgxMGZiNjg5Pl0gX19maWxlbWFwX2ZkYXRhd3Jp
dGVfcmFuZ2UrMHg0OS8weDUwClsgIDgzNS4yNjY1NDJdICBbPGZmZmZmZmZmODEwZmM0MWU+XSBm
aWxlbWFwX2ZkYXRhd3JpdGVfcmFuZ2UrMHhlLzB4MTAKWyAgODM1LjI2NjU0Nl0gIFs8ZmZmZmZm
ZmY4MTJhYjAxYz5dIGJ0cmZzX3N5bmNfZmlsZSsweGFjLzB4MzgwClsgIDgzNS4yNjY1NTNdICBb
PGZmZmZmZmZmODE3YWVlMzI+XSA/IF9fc2NoZWR1bGUrMHg2OTIvMHg3MzAKWyAgODM1LjI2NjU1
OV0gIFs8ZmZmZmZmZmY4MTE3NTJkOD5dIGRvX2ZzeW5jKzB4NTgvMHg5MApbICA4MzUuMjY2NTYz
XSAgWzxmZmZmZmZmZjgxMTQ4YTZkPl0gPyBTeVNfd3JpdGUrMHg0ZC8weGEwClsgIDgzNS4yNjY1
NjhdICBbPGZmZmZmZmZmODExNzU2NWI+XSBTeVNfZnN5bmMrMHhiLzB4MTAKWyAgODM1LjI2NjU3
Ml0gIFs8ZmZmZmZmZmY4MTdiODQyMj5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpb
ICA4MzUuMjY2NTc5XSBbYnRyZnNfc3luY19maWxlXSBpbnVtOiAoMjU4LCA1KSwgY2FsbGVkIHdy
aXRlX3JhbmdlLCBzdGFydDogMCwgZW5kOiA5MjIzMzcyMDM2ODU0Nzc1ODA3LCByZXQ6IDAKWyAg
ODM1LjI2NjU4MV0gW2J0cmZzX3N5bmNfZmlsZV0gaW51bTogKDI1OCwgNSksIGNhbGxpbmcgYnRy
ZnNfd2FpdF9vcmRlcmVkX3JhbmdlLCBzdGFydDogMCwgZW5kOiA5MjIzMzcyMDM2ODU0Nzc1ODA3
ClsgIDgzNS4yNjY1ODRdIFtkb193cml0ZXBhZ2VzXSBpbnVtOiAyNTgsIG5yX3RvX3dyaXRlOiA5
MjIzMzcyMDM2ODU0Nzc1ODA3LCB3cml0ZXBhZ2VzIGZuOiBmZmZmZmZmZjgxMjljZTQwClsgIDgz
NS4yNjY1ODddIENQVTogMCBQSUQ6IDEwMDIxIENvbW06IGJiIE5vdCB0YWludGVkIDMuMTIuMC1y
YzItbGF0ZXN0KyAjNwpbICA4MzUuMjY2NTg5XSBIYXJkd2FyZSBuYW1lOiBpbm5vdGVrIEdtYkgg
VmlydHVhbEJveCwgQklPUyBWaXJ0dWFsQm94IDEyLzAxLzIwMDYKWyAgODM1LjI2NjU5MF0gIGZm
ZmY4ODAwM2NkYzVlMjAgZmZmZjg4MDAzY2RjNWRlOCBmZmZmZmZmZjgxN2E4YWNmIDAwMDAwMDAw
MDAwMDAwMDcKWyAgODM1LjI2NjU5M10gIGZmZmY4ODAwMWY0NzhiMjggZmZmZjg4MDAzY2RjNWUw
OCBmZmZmZmZmZjgxMTA1YzFmIDAwMDAwMDAwMDAwMDAwMDAKWyAgODM1LjI2NjU5Nl0gIGZmZmY4
ODAwMWY0Nzg5ZTAgZmZmZjg4MDAzY2RjNWU0OCBmZmZmZmZmZjgxMGZiNjg5IGZmZmY4ODAwMzc1
NTc0MDAKWyAgODM1LjI2NjU5OV0gQ2FsbCBUcmFjZToKWyAgODM1LjI2NjYwM10gIFs8ZmZmZmZm
ZmY4MTdhOGFjZj5dIGR1bXBfc3RhY2srMHg0Ni8weDU4ClsgIDgzNS4yNjY2MDddICBbPGZmZmZm
ZmZmODExMDVjMWY+XSBkb193cml0ZXBhZ2VzKzB4NGYvMHg5MApbICA4MzUuMjY2NjEwXSAgWzxm
ZmZmZmZmZjgxMGZiNjg5Pl0gX19maWxlbWFwX2ZkYXRhd3JpdGVfcmFuZ2UrMHg0OS8weDUwClsg
IDgzNS4yNjY2MTNdICBbPGZmZmZmZmZmODEwZmM0MWU+XSBmaWxlbWFwX2ZkYXRhd3JpdGVfcmFu
Z2UrMHhlLzB4MTAKWyAgODM1LjI2NjYxOF0gIFs8ZmZmZmZmZmY4MTJiMmFkOD5dIGJ0cmZzX3dh
aXRfb3JkZXJlZF9yYW5nZSsweDU4LzB4MTAwClsgIDgzNS4yNjY2MjFdICBbPGZmZmZmZmZmODEy
YWIxMTg+XSBidHJmc19zeW5jX2ZpbGUrMHgxYTgvMHgzODAKWyAgODM1LjI2NjYyNV0gIFs8ZmZm
ZmZmZmY4MTdhZWUzMj5dID8gX19zY2hlZHVsZSsweDY5Mi8weDczMApbICA4MzUuMjY2NjI5XSAg
WzxmZmZmZmZmZjgxMTc1MmQ4Pl0gZG9fZnN5bmMrMHg1OC8weDkwClsgIDgzNS4yNjY2MzJdICBb
PGZmZmZmZmZmODExNDhhNmQ+XSA/IFN5U193cml0ZSsweDRkLzB4YTAKWyAgODM1LjI2NjYzNl0g
IFs8ZmZmZmZmZmY4MTE3NTY1Yj5dIFN5U19mc3luYysweGIvMHgxMApbICA4MzUuMjY2NjQwXSAg
WzxmZmZmZmZmZjgxN2I4NDIyPl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgIDgz
NS4yNjY2NDddIFtidHJmc19zeW5jX2ZpbGVdIGludW06ICgyNTgsIDUpLCByZXR1cm4gZnJvbSBs
b2dfZGVudHJ5LCBzdGFydDogMCwgZW5kOiA5MjIzMzcyMDM2ODU0Nzc1ODA3LCByZXQ6IDEKClsg
IDg2NS4zMTIwODJdIFtkb193cml0ZXBhZ2VzXSBpbnVtOiAyNTgsIG5yX3RvX3dyaXRlOiAzMDcy
LCB3cml0ZXBhZ2VzIGZuOiBmZmZmZmZmZjgxMjljZTQwClsgIDg2NS4zMTIwOTBdIENQVTogMCBQ
SUQ6IDcxMSBDb21tOiBrd29ya2VyL3UyOjUgTm90IHRhaW50ZWQgMy4xMi4wLXJjMi1sYXRlc3Qr
ICM3ClsgIDg2NS4zMTIwOTNdIEhhcmR3YXJlIG5hbWU6IGlubm90ZWsgR21iSCBWaXJ0dWFsQm94
LCBCSU9TIFZpcnR1YWxCb3ggMTIvMDEvMjAwNgpbICA4NjUuMzEyMTAwXSBXb3JrcXVldWU6IHdy
aXRlYmFjayBiZGlfd3JpdGViYWNrX3dvcmtmbiAoZmx1c2gtYnRyZnMtMikKWyAgODY1LjMxMjEw
NF0gIGZmZmY4ODAwM2M3OTNiNjAgZmZmZjg4MDAzYzc5M2E4OCBmZmZmZmZmZjgxN2E4YWNmIGZm
ZmY4ODAwM2ZjMGViNDgKWyAgODY1LjMxMjEwN10gIGZmZmY4ODAwMWY0NzhiMjggZmZmZjg4MDAz
Yzc5M2FhOCBmZmZmZmZmZjgxMTA1YzFmIGZmZmY4ODAwMWY0Nzg5ZTAKWyAgODY1LjMxMjExMF0g
IGZmZmY4ODAwM2M3OTNiNjAgZmZmZjg4MDAzYzc5M2IwOCBmZmZmZmZmZjgxMTZlYTMwIGZmZmY4
ODAwMzljYWYzOTgKWyAgODY1LjMxMjExM10gQ2FsbCBUcmFjZToKWyAgODY1LjMxMjEyMV0gIFs8
ZmZmZmZmZmY4MTdhOGFjZj5dIGR1bXBfc3RhY2srMHg0Ni8weDU4ClsgIDg2NS4zMTIxMjZdICBb
PGZmZmZmZmZmODExMDVjMWY+XSBkb193cml0ZXBhZ2VzKzB4NGYvMHg5MApbICA4NjUuMzEyMTMx
XSAgWzxmZmZmZmZmZjgxMTZlYTMwPl0gX193cml0ZWJhY2tfc2luZ2xlX2lub2RlKzB4YTAvMHgy
NjAKWyAgODY1LjMxMjEzNV0gIFs8ZmZmZmZmZmY4MTE2Zjc0MT5dIHdyaXRlYmFja19zYl9pbm9k
ZXMrMHgyYjEvMHg0MzAKWyAgODY1LjMxMjEzOV0gIFs8ZmZmZmZmZmY4MTE2ZjkzZT5dIF9fd3Jp
dGViYWNrX2lub2Rlc193YisweDdlLzB4YzAKWyAgODY1LjMxMjE0M10gIFs8ZmZmZmZmZmY4MTE3
MDAwYj5dIHdiX3dyaXRlYmFjaysweDE4Yi8weDJlMApbICA4NjUuMzEyMTQ3XSAgWzxmZmZmZmZm
ZjgxMTcwMWUzPl0gd2JfY2hlY2tfb2xkX2RhdGFfZmx1c2grMHg4My8weGIwClsgIDg2NS4zMTIx
NTFdICBbPGZmZmZmZmZmODExNzFhYWM+XSBiZGlfd3JpdGViYWNrX3dvcmtmbisweDFkYy8weDQ0
MApbICA4NjUuMzEyMTU3XSAgWzxmZmZmZmZmZjgxMDVmMTljPl0gcHJvY2Vzc19vbmVfd29yaysw
eDJiYy8weDQzMApbICA4NjUuMzEyMTYxXSAgWzxmZmZmZmZmZjgxMDYwMGM1Pl0gd29ya2VyX3Ro
cmVhZCsweDIxNS8weDMyMApbICA4NjUuMzEyMTY1XSAgWzxmZmZmZmZmZjgxMDVmZWIwPl0gPyBt
YW5hZ2Vfd29ya2Vycy5pc3JhLjE4KzB4MmIwLzB4MmIwClsgIDg2NS4zMTIxNjldICBbPGZmZmZm
ZmZmODEwNjY2ZjY+XSBrdGhyZWFkKzB4YjYvMHhjMApbICA4NjUuMzEyMTcyXSAgWzxmZmZmZmZm
ZjgxMDY2NjQwPl0gPyBmbHVzaF9rdGhyZWFkX3dvcmtlcisweGEwLzB4YTAKWyAgODY1LjMxMjE3
OF0gIFs8ZmZmZmZmZmY4MTdiODM3Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgIDg2NS4z
MTIxODFdICBbPGZmZmZmZmZmODEwNjY2NDA+XSA/IGZsdXNoX2t0aHJlYWRfd29ya2VyKzB4YTAv
MHhhMApbICA4NjUuMzEyMTg4XSBbX19leHRlbnRfd3JpdGVwYWdlXSBpbnVtOiAoMjU4LCA1KQpb
ICA4NjUuMzEyMTkxXSBDUFU6IDAgUElEOiA3MTEgQ29tbToga3dvcmtlci91Mjo1IE5vdCB0YWlu
dGVkIDMuMTIuMC1yYzItbGF0ZXN0KyAjNwpbICA4NjUuMzEyMTkyXSBIYXJkd2FyZSBuYW1lOiBp
bm5vdGVrIEdtYkggVmlydHVhbEJveCwgQklPUyBWaXJ0dWFsQm94IDEyLzAxLzIwMDYKWyAgODY1
LjMxMjE5Nl0gV29ya3F1ZXVlOiB3cml0ZWJhY2sgYmRpX3dyaXRlYmFja193b3JrZm4gKGZsdXNo
LWJ0cmZzLTIpClsgIDg2NS4zMTIxOThdICBmZmZmZWEwMDAwYjkzNzAwIGZmZmY4ODAwM2M3OTM4
MDggZmZmZmZmZmY4MTdhOGFjZiAwMDAwMDAwMDAwMDAwMDA3ClsgIDg2NS4zMTIyMDFdICBmZmZm
ODgwMDFmNDc4ODUwIGZmZmY4ODAwM2M3OTM5MTggZmZmZmZmZmY4MTJiN2NmMiBmZmZmODgwMDNj
NzkzODc4ClsgIDg2NS4zMTIyMDRdICBmZmZmZmZmZjgxN2EzNmFlIGZmZmY4ODAwM2M3OTM4ODgg
ZmZmZmZmZmYwMDAwMDAyMCBmZmZmODgwMDNjNzkzODg4ClsgIDg2NS4zMTIyMDddIENhbGwgVHJh
Y2U6ClsgIDg2NS4zMTIyMTFdICBbPGZmZmZmZmZmODE3YThhY2Y+XSBkdW1wX3N0YWNrKzB4NDYv
MHg1OApbICA4NjUuMzEyMjE2XSAgWzxmZmZmZmZmZjgxMmI3Y2YyPl0gX19leHRlbnRfd3JpdGVw
YWdlKzB4ODIvMHg3NzAKWyAgODY1LjMxMjIxOV0gIFs8ZmZmZmZmZmY4MTdhMzZhZT5dID8gcHJp
bnRrKzB4NWMvMHg1ZQpbICA4NjUuMzEyMjIyXSAgWzxmZmZmZmZmZjgxMDY2NjQwPl0gPyBmbHVz
aF9rdGhyZWFkX3dvcmtlcisweGEwLzB4YTAKWyAgODY1LjMxMjIyNl0gIFs8ZmZmZmZmZmY4MTBm
YWM3MT5dID8gZmluZF9nZXRfcGFnZXNfdGFnKzB4MTIxLzB4MTYwClsgIDg2NS4zMTIyMzFdICBb
PGZmZmZmZmZmODEyYjg1YjI+XSBleHRlbnRfd3JpdGVfY2FjaGVfcGFnZXMuaXNyYS4yNC5jb25z
dHByb3AuMzErMHgxZDIvMHgzODAKWyAgODY1LjMxMjIzNV0gIFs8ZmZmZmZmZmY4MTAwNTg3Nz5d
ID8gc2hvd190cmFjZV9sb2dfbHZsKzB4NTcvMHg3MApbICA4NjUuMzEyMjM5XSAgWzxmZmZmZmZm
ZjgxMmI4YTM5Pl0gZXh0ZW50X3dyaXRlcGFnZXMrMHg0OS8weDYwClsgIDg2NS4zMTIyNDRdICBb
PGZmZmZmZmZmODEyOWYxNjA+XSA/IGJ0cmZzX3N1Ym1pdF9kaXJlY3QrMHg2YzAvMHg2YzAKWyAg
ODY1LjMxMjI0N10gIFs8ZmZmZmZmZmY4MTI5Y2U2Mz5dIGJ0cmZzX3dyaXRlcGFnZXMrMHgyMy8w
eDMwClsgIDg2NS4zMTIyNTFdICBbPGZmZmZmZmZmODExMDVjM2U+XSBkb193cml0ZXBhZ2VzKzB4
NmUvMHg5MApbICA4NjUuMzEyMjU1XSAgWzxmZmZmZmZmZjgxMTZlYTMwPl0gX193cml0ZWJhY2tf
c2luZ2xlX2lub2RlKzB4YTAvMHgyNjAKWyAgODY1LjMxMjI1OV0gIFs8ZmZmZmZmZmY4MTE2Zjc0
MT5dIHdyaXRlYmFja19zYl9pbm9kZXMrMHgyYjEvMHg0MzAKWyAgODY1LjMxMjI2M10gIFs8ZmZm
ZmZmZmY4MTE2ZjkzZT5dIF9fd3JpdGViYWNrX2lub2Rlc193YisweDdlLzB4YzAKWyAgODY1LjMx
MjI2N10gIFs8ZmZmZmZmZmY4MTE3MDAwYj5dIHdiX3dyaXRlYmFjaysweDE4Yi8weDJlMApbICA4
NjUuMzEyMjcxXSAgWzxmZmZmZmZmZjgxMTcwMWUzPl0gd2JfY2hlY2tfb2xkX2RhdGFfZmx1c2gr
MHg4My8weGIwClsgIDg2NS4zMTIyNzVdICBbPGZmZmZmZmZmODExNzFhYWM+XSBiZGlfd3JpdGVi
YWNrX3dvcmtmbisweDFkYy8weDQ0MApbICA4NjUuMzEyMjc5XSAgWzxmZmZmZmZmZjgxMDVmMTlj
Pl0gcHJvY2Vzc19vbmVfd29yaysweDJiYy8weDQzMApbICA4NjUuMzEyMjgzXSAgWzxmZmZmZmZm
ZjgxMDYwMGM1Pl0gd29ya2VyX3RocmVhZCsweDIxNS8weDMyMApbICA4NjUuMzEyMjg3XSAgWzxm
ZmZmZmZmZjgxMDVmZWIwPl0gPyBtYW5hZ2Vfd29ya2Vycy5pc3JhLjE4KzB4MmIwLzB4MmIwClsg
IDg2NS4zMTIyOTBdICBbPGZmZmZmZmZmODEwNjY2ZjY+XSBrdGhyZWFkKzB4YjYvMHhjMApbICA4
NjUuMzEyMjkzXSAgWzxmZmZmZmZmZjgxMDY2NjQwPl0gPyBmbHVzaF9rdGhyZWFkX3dvcmtlcisw
eGEwLzB4YTAKWyAgODY1LjMxMjI5N10gIFs8ZmZmZmZmZmY4MTdiODM3Yz5dIHJldF9mcm9tX2Zv
cmsrMHg3Yy8weGIwClsgIDg2NS4zMTIzMDFdICBbPGZmZmZmZmZmODEwNjY2NDA+XSA/IGZsdXNo
X2t0aHJlYWRfd29ya2VyKzB4YTAvMHhhMApbICA4NjUuMzEyMzA5XSBbcnVuX2RlbGFsbG9jX3Jh
bmdlXSBpbnVtOiAoMjU4LCA1KSwgYWxsb2Mgc3RhcnQ6IDAsIGVuZDogNDA5NQoK
--089e01183c5c7e9e9404e7b32149--
