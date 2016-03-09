Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18.italiaonline.it ([212.48.25.146]:49732 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbcCIUuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 15:50:08 -0500
Reply-To: kreijack@inwind.it
Subject: Re: dstat shows unexpected result for two disk RAID1
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
 <CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
To: Nicholas D Steeves <nsteeves@gmail.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56E08C7D.3040304@inwind.it>
Date: Wed, 9 Mar 2016 21:50:05 +0100
MIME-Version: 1.0
In-Reply-To: <CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-09 21:25, Nicholas D Steeves wrote:
> grr.  Gmail is terrible :-/
> 
> I understood that a btrfs RAID1 would at best grab one block from sdb
> and then one block from sdd in round-robin fashion, or at worse grab
> one chunk from sdb and then one chunk from sdd.  Alternatively I
> thought that it might read from both simultaneously, to make sure that
> all data matches, while at the same time providing single-disk
> performance.  None of these was the case.  Running a single
> IO-intensive process reads from a single drive.
> 
> Did I misunderstand the documentation and is this normal, or is this a bug?
> Nicholas

In a case of a BTRFS RAID, I knew that a process read from a drive depending by its pid. 
I don't know if it is changed. But what from you write it seems that it still true today.



> 
> On 9 March 2016 at 15:21, Nicholas D Steeves <nsteeves@gmail.com> wrote:
>> Hello everyone,
>>
>> I've run into an expected behaviour for a my two disk RAID1.  I mount
>> with UUIDs, because sometimes my USB disk gets /dev/sdc instead of
>> /dev/sdd.  The two elements of my RAID1 are currently sdb and sdd.
>>
>> dstat -tdD total,sdb,sdc,sdd
>>
>> It seems that per process, reads come from either sdb or sdd.  This
>> surprises me, because I understood that a btrfs RAID1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
