From: "Marc R. O'Connor" <mroconnor@oel.state.nj.us>
Subject: Re: kernel bug in file-item.c
Date: Wed, 29 Apr 2009 14:38:09 -0400
Message-ID: <49F89E91.3020604@oel.state.nj.us>
References: <49F73F69.4010205@oel.state.nj.us>
 <1240946633.15136.55.camel@think.oraclecorp.com>
 <49F87A7F.7090804@oel.state.nj.us>
 <1241027618.20099.48.camel@think.oraclecorp.com>
 <49F89AB4.2090001@oel.state.nj.us>
 <1241029841.20099.53.camel@think.oraclecorp.com>
Reply-To: mroconnor@oel.state.nj.us
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_PcaDAKDBDDVwRAHjF4VavA)"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1241029841.20099.53.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_PcaDAKDBDDVwRAHjF4VavA)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT



Chris Mason wrote:
> On Wed, 2009-04-29 at 14:21 -0400, Marc R. O'Connor wrote:
>> Chris Mason wrote:
>>> On Wed, 2009-04-29 at 12:04 -0400, Marc R. O'Connor wrote:
>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>> Hash: SHA1
>>>>
>>>> full file-item.c attached
>>>>
>>>> Chris Mason wrote:
>>>>> On Tue, 2009-04-28 at 13:39 -0400, Marc R. O'Connor wrote:
>>>>>> I have had two 'kernel bug' issues today both referencing file-item.c.
>>>>>> The first oops happened when i was cp'ing from and external HD(ext3) to
>>>>>> and ext3 partition. The second happened during boot up. I have attached
>>>>>> them both.
>>>>>>
>>>>>> Im using btrfs that was merged into my kernel yesterday.
>>>>>>
>>>>>> plain text document attachment (btrfs_bug_1)
>>>>>> Apr 28 10:55:10 cosmo2 ------------[ cut here ]------------
>>>>>> Apr 28 10:55:10 cosmo2 kernel BUG at fs/btrfs/file-item.c:494!
>>>>> Well, I think I see the bug.  It looks like we want to do
>>>>>
>>>>> -        if (key->offset < bytenr && csum_end <= end_byte) {
>>>>> +        if (key->offset <= bytenr && csum_end <= end_byte) {
>>>>>
>>>>> in truncate_one_csum.  But I need to test that here for a bit and send
>>>>> you a patch.
>>> Ok, line 494 is actually this one ;)
>>>
>>>                 key->offset = end_byte;
>>>                 ret = btrfs_set_item_key_safe(trans, root, path, key);
>>>                 BUG_ON(ret); <---- 494
>>>
>>> Which means we're finding things out of order in the btree leaf.
>>>
>>> Could you please run btrfsck on this filesystem?
>>>
> 
>> I have done that on all btrfs partitions I have and btrfsck did not
>> return anything odd.
>>
> 
> In that case, the bad ordering is being introduced at run time.  Could
> you please run memtest86 on the box?
> 
> -chris
> 
> 
 memtest comes back with two errors very early on then reboots the
sysrescueCD. :(
-- 

--
Marc R. O'Connor
Information Systems
Camden County Board of Social Services
600 Market St.
Camden, NJ 08102
mroconnor@oel.state.nj.us
856-225-8915 Ofc.
609-206-3458 Blackberry
319D8AF1 BB PIN


--Boundary_(ID_PcaDAKDBDDVwRAHjF4VavA)
Content-type: text/x-vcard; charset=utf-8; name=mroconnor.vcf
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=mroconnor.vcf

begin:vcard
fn:Marc O'Connor
n:O'Connor;Marc
org:Camden County Board of Social Services;Information Technology
adr:;;600 Market St.;Camden;NJ;08102;USA
email;internet:mroconnor@oel.state.nj.us
tel;work:856-225-8915
tel;cell:609-206-3458
version:2.1
end:vcard


--Boundary_(ID_PcaDAKDBDDVwRAHjF4VavA)
Content-type: Text/Plain; name=disclaimer.txt
Content-transfer-encoding: 7BIT
Content-disposition: attachment; Filename=disclaimer.txt
X-NAIMIME-Disclaimer: 1
X-NAIMIME-Modified: 1

This E-mail, including any attachments, may be intended solely for the personal 
and confidential use of the sender and recipient(s) named above. This message 
may include advisory, consultative and/or deliberative material and, as such, 
would be privileged and confidential and not a public document. Any Information 
in this e-mail identifying a client of the Department of Human Services is 
confidential. If you have received this e-mail in error, you must not review, 
transmit, convert to hard copy, copy, use or disseminate this e-mail or any 
attachments to it and you must delete this message. You are requested to notify 
the sender by return e-mail.

--Boundary_(ID_PcaDAKDBDDVwRAHjF4VavA)--
