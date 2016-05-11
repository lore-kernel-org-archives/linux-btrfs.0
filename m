Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbcEKL44 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 07:56:56 -0400
Subject: Re: [PATCH] btrfs: switch to common message helpers in open_ctree,
 adjust messages
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1462786798-15247-1-git-send-email-dsterba@suse.com>
 <573148AB.6080800@oracle.com> <20160510074203.GP29353@twin.jikos.cz>
 <57319541.7000300@oracle.com> <20160510082120.GQ29353@twin.jikos.cz>
 <57319E9A.8070003@oracle.com> <20160510142856.GV29353@twin.jikos.cz>
 <5731F771.2060509@oracle.com> <20160511105619.GZ29353@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57331DCD.2090600@oracle.com>
Date: Wed, 11 May 2016 19:55:57 +0800
MIME-Version: 1.0
In-Reply-To: <20160511105619.GZ29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 05/11/2016 06:56 PM, David Sterba wrote:
> On Tue, May 10, 2016 at 11:00:01PM +0800, Anand Jain wrote:
>>>>     If there is something that works simple, better. I am fine.
>>>>
>>>>     Generally servers may have more than one fs mounted. So filter
>>>>     by fsid comes handy. Without worrying about when it was labeled,
>>>>     and troubleshooting scripts to fail.
>>>
>>> The idea is:
>>>
>>>     mount -o log=fsid /dev/sda /mnt/path
>>
>>
>>    This makes life of a 3rd party troubleshooter more difficult. As it
>>    needs to be understood what mount option was used, and if its not
>>    changed in between by the customer, and if the logs by filter won't
>>    show some of the critical logs, would lead to a wrong analysis of
>>    the issue.
>>
>>    But whats the concern for print FSID by default (without having to
>>    come through the -o log=fsid) ?
>
> Concerns as I see them:


> * current default is to print the device name -- so this would mean a
>    forced change in defaults
> * the FSID is not very human friendly. I can remember several device
>    names and I'll probably know which filesystem is on which
> * the FSID is very long, consumes half of the line before the actual
>    message starts

   Yes, indeed. I think we discussed that there isn't any other
   alternative as well. Also I was thinking something like in
   the 'git log --online' output but that might conflict in some
   cases ? (recently there was a progs patch which fixed the short fsid
   hash conflict).

> I understand the benefits of automated filtering by FSID, but we have
> conflicting interests here. If you're going to deploy automated log
> scanning, you probably have automated the filesystem mkfs & mount, so
> it's a matter of configuration to get it done and in one place.

   Makes sense.

   Actually automated scripts wasn't in my discussion, I was thinking
   of support engineers debugging customer issues using hand written
   scripts.

   Probably we could taken an experimental project, to have these
   logs in cvs format, and use external scripts to monitor and
   debug. Make something like splunk.com an easy job.


>>    Just my understanding:
>>    For real end users we need to provide everything at the cli output.
>>    That is without asking them to refer to dmesg in the cli out put. IMO.
>>    (I could be wrong). Troubleshooters are the people looking at dmesg.
>>    So finding the FSID can be expected ?
>
> I don't think that looking up device names is making troubleshooting
> significantly harder and never found it to be a problem in my past
> experienes.
>
> Besides, errors from lower layers report the device names, so bad
> sectors or failed writes pop up very quickly in the searches.

  Right. FSID won't provide that advantage.

> Either way, I'm willing to make it configurable so it addresses all
> usecases.


> Another way came to my mind: make it a module parameter, so
> even the mount option or sysfs settings is not needed and the defaults
> are system-wide.

  Yep. This helps.
  I was thinking from the angle of support engineers, who would
  solve customers issues (it happens at most of the Linux vendors),
  They would write/run scripts on their own to understand the problem
  from the kernel logs. So now it can be assured that logs format
  would remain same per distribution/vendor.

Thanks for taking time to explain.

- Anand


>>    Further there is nothing avoids user not to label two FS with the
>>    same label.
>
> That's true and users' responsibility not to shoot themselves.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
