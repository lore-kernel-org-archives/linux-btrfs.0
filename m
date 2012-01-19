From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [BUG - btrfs] kernel oops in extent_range_uptodate
Date: Thu, 19 Jan 2012 10:24:19 -0600
Message-ID: <CAKcLGm9kVOw6D8kPECfhfohH4pAT=09qws7-jRsh1TZJTyh1_A@mail.gmail.com>
References: <4F182BED.3090009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F182BED.3090009@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 19, 2012 at 8:42 AM, Vincent Vanackere
<vincent.vanackere@gmail.com> wrote:
> Hi,
>
> With the most current git kernel (90a4c0f51e8e44111a926be6f4c87af3938a79c3)
> I'm still getting the same reproducible kernel panic when trying to read a
> particular file stored on a btrfs filesystem (as seen in the log there are
> indeed disk media errors on this disk).
> I'd like the "software" part of this to be fixed - btrfs should definitely
> not oops even in case of media error - before sending the disk to RMA. Is
> there anything I can do to make progress on this ?
>

Is this kernel compiled with "Compile the kernel with debug info" (in
the "Kernel hacking  --->" configuration section)?

It would be nice to have the specific line of code passing the NULL pointer.
