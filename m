From: "Marc R. O'Connor" <mroconnor@oel.state.nj.us>
Subject: Re: kernel bug in file-item.c
Date: Wed, 29 Apr 2009 14:46:48 -0400
Message-ID: <49F8A098.4020106@oel.state.nj.us>
References: <49F73F69.4010205@oel.state.nj.us>
 <1240946633.15136.55.camel@think.oraclecorp.com>
 <49F87A7F.7090804@oel.state.nj.us>
 <1241027618.20099.48.camel@think.oraclecorp.com>
 <49F89AB4.2090001@oel.state.nj.us>
 <1241029841.20099.53.camel@think.oraclecorp.com>
 <49F89E91.3020604@oel.state.nj.us>
 <1241030419.20099.55.camel@think.oraclecorp.com>
Reply-To: mroconnor@oel.state.nj.us
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_heolF4E3xFvXg+QBKvoHJg)"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1241030419.20099.55.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_heolF4E3xFvXg+QBKvoHJg)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT

To be honest I have no idea. Let me see if I can find a different
version to test with and see. I think I'm still under warranty. ;)

Chris Mason wrote:
> On Wed, 2009-04-29 at 14:38 -0400, Marc R. O'Connor wrote:
>>>> I have done that on all btrfs partitions I have and btrfsck did not
>>>> return anything odd.
>>>>
>>> In that case, the bad ordering is being introduced at run time.  Could
>>> you please run memtest86 on the box?
>>>
>>> -chris
>>>
>>>
>>  memtest comes back with two errors very early on then reboots the
>> sysrescueCD. :(
> 
> Well, then I'm surprised btrfs doesn't crash more violently and more
> often ;)
> 
> Do you think you're hitting a memtest bug or is the HW really bad?
> 
> -chris
> 
> 
> 
> 

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


--Boundary_(ID_heolF4E3xFvXg+QBKvoHJg)
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


--Boundary_(ID_heolF4E3xFvXg+QBKvoHJg)
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

--Boundary_(ID_heolF4E3xFvXg+QBKvoHJg)--
