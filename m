Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A35C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 14:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F04802082B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 14:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="cv02gQZW";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="cv02gQZW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F04802082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mail.ru
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbeJZXe4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 19:34:56 -0400
Received: from fallback14.mail.ru ([94.100.179.44]:49574 "EHLO
        fallback14.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbeJZXe4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 19:34:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-ID:References:In-Reply-To:Subject:To:From:Date:Content-Type:MIME-Version; bh=t51gkuOb7hdwy3WFdolb9CkSA4N6+HLkfnHEicinKBs=;
        b=cv02gQZW5OjXnJiyB+JyheygDpecS6tP0rdTQDTaClOqFyvkVKKM4rZHRtTZXoxBBSD0NX8jwbs68hswrikGHWuepmYLetLCRcJpJ0CJLojGGLkqzXFKtUkRnXWEtpAgBfLGZZVzKr+rytZfXFaJE9de5PA64km9GO1xCuBKh+Q=;
Received: from [10.161.64.55] (port=58534 helo=smtp47.i.mail.ru)
        by fallback14.m.smailru.net with esmtp (envelope-from <dma_k@mail.ru>)
        id 1gG3YF-000740-H7
        for linux-btrfs@vger.kernel.org; Fri, 26 Oct 2018 17:57:27 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-ID:References:In-Reply-To:Subject:To:From:Date:Content-Type:MIME-Version; bh=t51gkuOb7hdwy3WFdolb9CkSA4N6+HLkfnHEicinKBs=;
        b=cv02gQZW5OjXnJiyB+JyheygDpecS6tP0rdTQDTaClOqFyvkVKKM4rZHRtTZXoxBBSD0NX8jwbs68hswrikGHWuepmYLetLCRcJpJ0CJLojGGLkqzXFKtUkRnXWEtpAgBfLGZZVzKr+rytZfXFaJE9de5PA64km9GO1xCuBKh+Q=;
Received: by smtp47.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
        id 1gG3YD-0007bR-2X
        for linux-btrfs@vger.kernel.org; Fri, 26 Oct 2018 17:57:25 +0300
Received: from www.centurion.link (localhost [IPv6:::1])
        by centurion.home (Postfix) with ESMTP id 02E11F2913D
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 16:57:24 +0200 (CEST)
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_c83203375d9452d2681564a85854d988"
Date:   Fri, 26 Oct 2018 16:57:23 +0200
From:   Dmitry Katsubo <dma_k@mail.ru>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel crash related to LZO compression
In-Reply-To: <CAJCQCtQrPKMUaGgg-t+0q8fACy0cys_CBi_5CSp2mr+xa5TeNQ@mail.gmail.com>
References: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
 <CAJCQCtQrPKMUaGgg-t+0q8fACy0cys_CBi_5CSp2mr+xa5TeNQ@mail.gmail.com>
Message-ID: <456e4b3d-50f7-1f88-c503-fb3213abccca@mail.ru>
X-Sender: dma_k@mail.ru
User-Agent: Roundcube Webmail/1.2.3
X-77F55803: ABQATh8ydykdfC8LjbO7mDCqC+YBLPYOEUOLSum/u1W8jY/eigcMsw==
X-7FA49CB5: 0D63561A33F958A51D55B6579900B8BFAFBB9BC1A2A863770381A57B1554B7A88941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC8364767815B9869FA544D8D32BA5DBAC0009BE9E8FC8737B5C2249D827CA74CCEABFF33AA81AA40904B5D9CF19DD082D7633A0E7DDDDC251EA7DABD81D268191BDAD3D78DA827A17800CE767C209D01CC1E34BCD04E86FAF290E2D40A5AABA2AD3711975ECD9A6C639B01B78DA827A17800CE7CC5D2E9EFE8938D97E3324020B80CB4F75ECD9A6C639B01B4E70A05D1297E1BBC6867C52282FAC85D9B7C4F32B44FF57285124B2A10EEC6C00306258E7E6ABB4E4A6367B16DE6309
X-Mailru-Sender: 6DAAA20F2058E07D134D6D8D77B89E7FA8404108B3A064CAB3946D7C2B2B123ED234C9E63E727397501E7C294F69090ED50E20E2BC48EF5AE609D43F356B221EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: OK
X-77F55803: 6Ns2ePE+8+B2uBAt8D8br4kJnRWqiScC6S4nGHi1TLfUVoQop97kSA==
X-7FA49CB5: 0D63561A33F958A58D4D90E4FBF98747A3FDB99E058B855A4CCBD82AE49501798941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-Mailru-MI: 800
X-Mailru-Sender: A5480F10D64C9005EB82917A46D9527673EB381CDDD68F6D5A957526117A57DBA5946156EE097900D7448B40F9645FF708335C02508E532C672654BDC5BB03D95FEEDEB644C299C0ED14614B50AE0675
X-Mras: OK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--=_c83203375d9452d2681564a85854d988
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

On 2018-10-25 20:49, Chris Murphy wrote:
> I would say the first step no matter what if you're using an older
> kernel, is to boot a current Fedora or Arch live or install media,
> mount the Btrfs and try to read the problem files and see if the
> problem still happens. I can't even being to estimate the tens of
> thousands of line changes since kernel 4.9.

Good point Chris. Indeed booting a fresh kernel is never a problem.
Actually I forgot to mention that I've seen the same problem with
kernel 4.12.13 (attached).

> What profile are you using for this Btrfs? Is this a raid56? What do
> you get for 'btrfs fi us <mountpoint>' ?

It is RAID1 volume for both metadata and data, but unfortunately I
haven't recorded the actual output before the failure. The configuration
was like this:

# btrfs filesystem show /var/log
Label: none  uuid: 5b45ac8e-fd8c-4759-854a-94e45069959d
	Total devices 2 FS bytes used 11.13GiB
	devid    3 size 50.00GiB used 14.03GiB path /dev/sda3
	devid    4 size 50.00GiB used 14.03GiB path /dev/sdc1

On 2018-10-25 20:49, Chris Murphy wrote:
> It should be safe even with that kernel. I'm not sure this is
> compression related. There is a corruption bug related to inline
> extents and corruption that had been fairly elusive but I think it's
> fixed now. I haven't run into it though.

On 2018-10-26 02:09, Qu Wenruo wrote:
>> Are there any updates / fixes done in that area? Is lzo option safe to 
>> use?
> 
> Yes, we have commits to harden lzo decompress code in v4.18:
> 
> de885e3ee281a88f52283c7e8994e762e3a5f6bd btrfs: lzo: Harden inline lzo
> compressed extent decompression
> 314bfa473b6b6d3efe68011899bd718b349f29d7 btrfs: lzo: Add header length
> check to avoid potential out-of-bounds acc
> 
> And for the root cause, it's compressed data without csum, then scrub
> could make it corrupted.
> 
> It's also fixed in v4.18:
> 
> 665d4953cde6d9e75c62a07ec8f4f8fd7d396ade btrfs: scrub: Don't use inode
> page cache in scrub_handle_errored_block()
> ac0b4145d662a3b9e34085dea460fb06ede9b69b btrfs: scrub: Don't use inode
> pages for device replace

Thanks, Qu, for this information. Actually one time I've seen the binary
crap (not zeros) in text log files (/var/log/*.log) and I was surprised
that btrfs returned me data which is corrupted instead of signalling I/O
error. Could it be because of "compressed data without csum" problem?

Thanks!

-- 
With best regards,
Dmitry

--=_c83203375d9452d2681564a85854d988
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=dmesg.2017-12-03.txt
Content-Disposition: attachment;
 filename=dmesg.2017-12-03.txt;
 size=2906

W1N1biBEZWMgIDMgMTk6Mzk6NTUgMjAxN10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBw
YWdpbmcgcmVxdWVzdCBhdCBmODBhMzAwMApbU3VuIERlYyAgMyAxOTozOTo1NSAyMDE3XSBJUDog
bWVtY3B5KzB4MTEvMHgyMApbU3VuIERlYyAgMyAxOTozOTo1NSAyMDE3XSAqcGRlID0gMzcwYmIw
NjcgCltTdW4gRGVjICAzIDE5OjM5OjU1IDIwMTddICpwdGUgPSAwMDAwMDAwMCAKW1N1biBEZWMg
IDMgMTk6Mzk6NTUgMjAxN10gT29wczogMDAwMiBbIzFdIFNNUApbU3VuIERlYyAgMyAxOTozOTo1
NSAyMDE3XSBNb2R1bGVzIGxpbmtlZCBpbjogYnJpZGdlIHN0cCBsbGMgYXJjNCBpVENPX3dkdCBp
VENPX3ZlbmRvcl9zdXBwb3J0IHBwZGV2IGF0aDVrIGV2ZGV2IGF0aCBtYWM4MDIxMSBjZmc4MDIx
MSBpOTE1IGNvcmV0ZW1wIHBjc3BrciByZmtpbGwgc25kX2hkYV9jb2RlY19yZWFsdGVrIHNlcmlv
X3JhdyBzbmRfaGRhX2NvZGVjX2dlbmVyaWMgdmlkZW8gc25kX2hkYV9pbnRlbCBkcm1fa21zX2hl
bHBlciBzbmRfaGRhX2NvZGVjIGxwY19pY2ggZHJtIHNuZF9oZGFfY29yZSBzbmRfaHdkZXAgaTJj
X2FsZ29fYml0IHNuZF9wY21fb3NzIHNuZF9taXhlcl9vc3MgZmJfc3lzX2ZvcHMgc2cgc25kX3Bj
bSBzeXNjb3B5YXJlYSBzbmRfdGltZXIgc3lzZmlsbHJlY3Qgcm5nX2NvcmUgc25kIHN5c2ltZ2Js
dCBzb3VuZGNvcmUgcGFycG9ydF9wYyBwYXJwb3J0IHNocGNocCBidXR0b24gYWNwaV9jcHVmcmVx
IGJpbmZtdF9taXNjIHc4MzYyN2hmIGh3bW9uX3ZpZCBpcF90YWJsZXMgeF90YWJsZXMgYXV0b2Zz
NCBzZXMgZW5jbG9zdXJlIHNjc2lfdHJhbnNwb3J0X3NhcyB4ZnMgbGliY3JjMzJjIGhpZF9nZW5l
cmljIHVzYmhpZCBoaWQgYnRyZnMgY3JjMzJjX2dlbmVyaWMgeG9yIHJhaWQ2X3BxIHVhcyB1c2Jf
c3RvcmFnZSBzcl9tb2QgY2Ryb20gc2RfbW9kIGF0YV9nZW5lcmljIGF0YV9waWl4IGkyY19pODAx
IGxpYmF0YSBzY3NpX21vZCBmaXJld2lyZV9vaGNpIGZpcmV3aXJlX2NvcmUgY3JjX2l0dV90IGVo
Y2lfcGNpIGUxMDAwZSBwdHAgcHBzX2NvcmUgdWhjaV9oY2QgZWhjaV9oY2QgdXNiY29yZSB1c2Jf
Y29tbW9uCltTdW4gRGVjICAzIDE5OjM5OjU1IDIwMTddIENQVTogMSBQSUQ6IDEwMCBDb21tOiBr
d29ya2VyL3U0OjIgVGFpbnRlZDogRyAgICAgICAgVyAgICAgICA0LjEyLjAtMi02ODYgIzEgRGVi
aWFuIDQuMTIuMTMtMQpbU3VuIERlYyAgMyAxOTozOTo1NSAyMDE3XSBIYXJkd2FyZSBuYW1lOiBB
T3BlbiBpOTQ1R014LUlGL2k5NDVHTXgtSUYsIEJJT1MgaTk0NUdNeC1JRiBSMS4wMSBNYXIuMDIu
MjAwNyBBT3BlbiBJbmMuIDAzLzAyLzIwMDcKW1N1biBEZWMgIDMgMTk6Mzk6NTUgMjAxN10gV29y
a3F1ZXVlOiBidHJmcy1lbmRpbyBidHJmc19lbmRpb19oZWxwZXIgW2J0cmZzXQpbU3VuIERlYyAg
MyAxOTozOTo1NSAyMDE3XSB0YXNrOiBmNzMzNzI4MCB0YXNrLnN0YWNrOiBmNjk1YzAwMApbU3Vu
IERlYyAgMyAxOTozOTo1NSAyMDE3XSBFSVA6IG1lbWNweSsweDExLzB4MjAKW1N1biBEZWMgIDMg
MTk6Mzk6NTUgMjAxN10gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDEKW1N1biBEZWMgIDMgMTk6Mzk6
NTUgMjAxN10gRUFYOiBmODBhMmZmOCBFQlg6IDAwMDAxMDAwIEVDWDogMDAwMDAzZmUgRURYOiBm
Zjk5ODAwMApbU3VuIERlYyAgMyAxOTozOTo1NSAyMDE3XSBFU0k6IGZmOTk4MDA4IEVESTogZjgw
YTMwMDAgRUJQOiAwMDAwMDAwMCBFU1A6IGY2OTVkZTg4CltTdW4gRGVjICAzIDE5OjM5OjU1IDIw
MTddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbU3VuIERl
YyAgMyAxOTozOTo1NSAyMDE3XSBDUjA6IDgwMDUwMDMzIENSMjogZjljMDAxNDAgQ1IzOiAzNmJj
NzAwMCBDUjQ6IDAwMDAwNmQwCltTdW4gRGVjICAzIDE5OjM5OjU1IDIwMTddIENhbGwgVHJhY2U6
CltTdW4gRGVjICAzIDE5OjM5OjU1IDIwMTddICA/IGx6b19kZWNvbXByZXNzX2JpbysweDE5Zi8w
eDJiMCBbYnRyZnNdCltTdW4gRGVjICAzIDE5OjM5OjU1IDIwMTddICA/IGVuZF9jb21wcmVzc2Vk
X2Jpb19yZWFkKzB4MjhkLzB4MzYwIFtidHJmc10KW1N1biBEZWMgIDMgMTk6Mzk6NTUgMjAxN10g
ID8gYnRyZnNfc2NydWJwYXJpdHlfaGVscGVyKzB4YjYvMHgyYzAgW2J0cmZzXQpbU3VuIERlYyAg
MyAxOTozOTo1NSAyMDE3XSAgPyBwcm9jZXNzX29uZV93b3JrKzB4MTM1LzB4MmYwCltTdW4gRGVj
ICAzIDE5OjM5OjU1IDIwMTddICA/IHdvcmtlcl90aHJlYWQrMHgzOS8weDNhMApbU3VuIERlYyAg
MyAxOTozOTo1NSAyMDE3XSAgPyBrdGhyZWFkKzB4ZDcvMHgxMTAKW1N1biBEZWMgIDMgMTk6Mzk6
NTUgMjAxN10gID8gcHJvY2Vzc19vbmVfd29yaysweDJmMC8weDJmMApbU3VuIERlYyAgMyAxOToz
OTo1NSAyMDE3XSAgPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MzAvMHgzMApbU3VuIERlYyAg
MyAxOTozOTo1NSAyMDE3XSAgPyByZXRfZnJvbV9mb3JrKzB4MTkvMHgyNApbU3VuIERlYyAgMyAx
OTozOTo1NSAyMDE3XSBDb2RlOiA0MyA1OCAyYiA0MyA1MCA4OCA0MyA0ZSA1YiBlYiBlZCA5MCA5
MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCAzZSA4ZCA3NCAyNiAwMCA1
NyA4OSBjNyA1NiA4OSBkNiA1MyA4OSBjYiBjMSBlOSAwMiA8ZjM+IGE1IDg5IGQ5IDgzIGUxIDAz
IDc0IDAyIGYzIGE0IDViIDVlIDVmIGMzIDNlIDhkIDc0IDI2IDAwIDU1CltTdW4gRGVjICAzIDE5
OjM5OjU1IDIwMTddIEVJUDogbWVtY3B5KzB4MTEvMHgyMCBTUzpFU1A6IDAwNjg6ZjY5NWRlODgK
W1N1biBEZWMgIDMgMTk6Mzk6NTUgMjAxN10gQ1IyOiAwMDAwMDAwMGY4MGEzMDAwCltTdW4gRGVj
ICAzIDE5OjM5OjU1IDIwMTddIC0tLVsgZW5kIHRyYWNlIGE5NjFkMzk1Njg3YWQyNjUgXS0tLQo=
--=_c83203375d9452d2681564a85854d988--
