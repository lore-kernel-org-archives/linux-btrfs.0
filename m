From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: fix enospc error caused by wrong checks of the
 chunk allocation
Date: Tue, 17 Jan 2012 13:27:17 -0600
Message-ID: <CAKcLGm-GvMAqX7so86E5318jgOy2izMfGaA4V1U4swWppuAyQQ@mail.gmail.com>
References: <4F153E33.8070803@cn.fujitsu.com>
	<CAKcLGm_HRMWcg4Aze59EFjQARbnQTSCxyfyPB4bS3f2R4kfvuQ@mail.gmail.com>
	<20120117163903.GD30322@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	miaox@cn.fujitsu.com, Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120117163903.GD30322@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 10:39 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> On Tue, Jan 17, 2012 at 10:31:00AM -0600, Mitch Harder wrote:
>> On Tue, Jan 17, 2012 at 3:24 AM, Miao Xie <miaox@cn.fujitsu.com> wro=
te:
>>
>> After applying this patch to the re-based integration branch, I was
>> able to clear an EFBIG error (that seemed to be related to chunk
>> allocation) I had previously been receiving while trying to balance =
a
>> partially corrupted partition.
>>
>> I was receiving this bug from the btrfs_add_system_chunk() function
>> which had do_chunk_alloc() close up in the callback list.
>
> The EFBIG error was my bug. =A0There's a commit in the new integratio=
n
> branch that fixes it (and an earlier one in integration that adds it)
>

I've confirmed that.  The error is cleared with just the rebased
integration branch.

Sorry, I was testing patches off the list to address the issue I was
seeing at the same time as the rebase.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
