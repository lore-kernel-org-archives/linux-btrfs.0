Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:38507 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbcALTz0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 14:55:26 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs-progs: Format change for btrfs fi df
References: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160112142806.GL4227@twin.jikos.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56955A2A.6070708@inwind.it>
Date: Tue, 12 Jan 2016 20:55:22 +0100
MIME-Version: 1.0
In-Reply-To: <20160112142806.GL4227@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-12 15:28, David Sterba wrote:
[...]
> How about this:
> 
> - keep the global reserve in the output, separate from metadata and not
>    accounted
> - add new option to account the global reserve into metadata and then
>    drop it from the output


Instead of dropping it, what about prefixing it with '\_' in order to show that
it is a subtype of metadata (it is not a my idea, I read this sometime ago in 
this mailing list) ?

$ btrfs fi df /
Data, single: total=29.00GiB, used=21.01GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=2.00GiB, used=716.59MiB
\_GlobalReserve, single: total=240.00MiB, used=0.00B

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
