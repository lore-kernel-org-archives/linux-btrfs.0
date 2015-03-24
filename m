Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22256 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932474AbbCXRfI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 13:35:08 -0400
Date: Tue, 24 Mar 2015 13:34:59 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: WARNING at fs/btrfs/super.c:260 __btrfs_abort_transaction
 (error -17)
To: Sophie Dexter <Just4pLeisure@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1427218499.30561.0@mail.thefacebook.com>
In-Reply-To: <merpmk$m16$1@ger.gmane.org>
References: <CAPmwjs9EVi-vY7FEfm+U-CYuxMms2iB-0i6mMLShdJMO6pGYjQ@mail.gmail.com>
	<merpmk$m16$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Mar 24, 2015 at 9:43 AM, Sophie Dexter 
<Just4pLeisure@gmail.com> wrote:
> On 20/03/2015 15:19, Sophie Dexter wrote:
>> I'm given to understand that this is the right place to report a 
>> btrfs
>> problem, I apologise if not :-(
>> 
>> I have been using my router as a simple NFS NAS for around 2 years
>> with an ext3 formatted 2 TB Western Digital 2.5" USB Passport disk. I
>> have been slowly moving to BTRFS and thought it about time to convert
>> this disk too but unfortunately BTRFS is unreliable on my router :-(.
>> It doesn't take long for an error to happen causing a 'ro' remount.
>> However the disk is unreadable after the remount, both for NFS and
>> locally. Rebooting the router seems to be the only way to access the
>> disk again.
>> 
>> I also have a 1 GB swap partition on the disk although swap doesn't
>> appear to be a factor as the problem occurs whether or not swap is
>> enabled (this report is without swap).
>> 
>> I used my laptop to convert the fs to btrfs, not my router. My laptop
>> has Fedora 21 with 3.18 kernel and tools. No problems are found when 
>> I
>> use my laptop to check and scrub the disk (i.e. with the disk
>> connected directly to my laptop).

You have great timing, there are two reports of a very similar abort 
with 4.0-rc5, but your report makes it clear these are not a regression 
from 4.0-rc4.

Are you able to run btrfsck on this filesystem?  I'd like to check for 
metadata inconsistencies.

-chris



