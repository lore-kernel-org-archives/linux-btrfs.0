Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50910 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaFZLGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 07:06:38 -0400
Message-ID: <1403780795.7657.7.camel@hsew-frn.HIPERSCAN>
Subject: Re: cancel btrfs delete job
From: Franziska =?ISO-8859-1?Q?N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
Reply-To: franziska.naepelt@hiperscan.com
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Thu, 26 Jun 2014 13:06:35 +0200
In-Reply-To: <1403596252.4221.9.camel@hsew-frn.HIPERSCAN>
References: <1403596252.4221.9.camel@hsew-frn.HIPERSCAN>
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Satoru,

here are your requested informations:

environment:

- four 2 TB disks: /dev/sd[c-f]
- two 3 TB disks: /dev/sdg (but until now, only one is connected)

filesystem consists of/dev/sd[c-f]

I wanted to replace /dev/sdc by /dev/sdg ( with commands add and after
that delete.
In the second step, I wanted to replace the next disk.

But it hanged during btrfs delete command (after successfull add).
The delete process was still in progress, but with iotop it seems to me,
that there is was no data transfer.


Today in the morning the hole computer hangs and there was no other
possibility than reset :(

Until now, he tries to boot with a lot of erros. But I can see, that
there are fileactions on the harddrive.

There are a lot of following messages:
btrfs free space inode generation (0) did not match free space cache
generation


best regards,
Franziska

-------- Weitergeleitete Nachricht --------
Von: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
An: franziska.naepelt@hiperscan.com, linux-btrfs@vger.kernel.org
<linux-btrfs@vger.kernel.org>
Betreff: Re: cancel btrfs delete job
Datum: Thu, 26 Jun 2014 16:17:30 +0900

Hi Franziska,

(2014/06/24 16:50), Franziska Näpelt wrote:
> Hi,
>
> i want to expand a btrfs filesystem. In the moment I have four 2 TB
HDDs
> for one btrfs pool.
> I want to replace two of the HDDs with 3 TB devices. For this reason i
> added as first one 3 TB device. After that, i do the btrfs delete job.
> This job lasts since 4 days and it seems, that it hangs.
>
> Is it possible to cancel a btrfs delete job?
> And when so, how can i do that?

Unfortunately you can't cancel btrfs delete.

Q1. Does your environment and operations are as follows?

Environment:
  - You have six disks.
    - four 2TB disks: /dev/sd[a-d]
    - two 3TB disks: /dev/sd[ef]
  - Currently your btrfs filesystem consists of /dev/sd[a-d].
  - You want to replace /dev/sd[cd] with /dev/[ef].

Your operation:
  1. Add one 3TB disk, /dev/sde.     # It works correctly.
  2. Delete one 2TB disk, /dev/sdc   # Hanged up happens here!

Q2. Does I/Os for delete still in progress, or there is no I/O?

Thanks,
Satoru

>
> Best regards,
> Franziska
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>





