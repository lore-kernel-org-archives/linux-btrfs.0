From: "Marc R. O'Connor" <mroconnor@oel.state.nj.us>
Subject: Re: kernel bug in file-item.c
Date: Tue, 28 Apr 2009 15:30:06 -0400
Message-ID: <49F7593E.6050407@oel.state.nj.us>
References: <49F73F69.4010205@oel.state.nj.us>
 <1240946633.15136.55.camel@think.oraclecorp.com>
Reply-To: mroconnor@oel.state.nj.us
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_Giddf74XT/RdtgJ3qUNKZg)"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1240946633.15136.55.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_Giddf74XT/RdtgJ3qUNKZg)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT



Chris Mason wrote:
> On Tue, 2009-04-28 at 13:39 -0400, Marc R. O'Connor wrote:
>> I have had two 'kernel bug' issues today both referencing file-item.c.
>> The first oops happened when i was cp'ing from and external HD(ext3) to
>> and ext3 partition. The second happened during boot up. I have attached
>> them both.
>>
>> Im using btrfs that was merged into my kernel yesterday.
>>
>> plain text document attachment (btrfs_bug_1)
>> Apr 28 10:55:10 cosmo2 ------------[ cut here ]------------
>> Apr 28 10:55:10 cosmo2 kernel BUG at fs/btrfs/file-item.c:494!
> 
> Well, I think I see the bug.  It looks like we want to do
> 
> -        if (key->offset < bytenr && csum_end <= end_byte) {
> +        if (key->offset <= bytenr && csum_end <= end_byte) {
> 
> in truncate_one_csum.  But I need to test that here for a bit and send
> you a patch.
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks, I am a patient kind of guy ;)

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


--Boundary_(ID_Giddf74XT/RdtgJ3qUNKZg)
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


--Boundary_(ID_Giddf74XT/RdtgJ3qUNKZg)
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

--Boundary_(ID_Giddf74XT/RdtgJ3qUNKZg)--
