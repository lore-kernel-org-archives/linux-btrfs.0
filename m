From: Daniel Kozlowski <dan.kozlowski@gmail.com>
Subject: Re: Recover Corruption - verify_parent_transid
Date: Tue, 10 Aug 2010 06:30:51 -0400
Message-ID: <AANLkTinK+JOZKzbZLQmimU72kj+3tbRdQLmCLbjL0ec0@mail.gmail.com>
References: <1281415061.3192.23.camel@hardline>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "A. James Lewis" <james@fsck.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1281415061.3192.23.camel@hardline>
List-ID: <linux-btrfs.vger.kernel.org>

I had a system in a simelar situation. In my case the fix was to
upgrade the btrfs module to git-head. After I did that tryig to mount
gave me an error is syslog about a problem it was having with one disk
before it went into the transid loop. i remove the disk and re-mounted
with -o degraded. hat allowed me to actually get teh drives mounted.
If your on a single disk setup i don't think that would work for you.
what you can do is check the syslog as you try to mount for  any OOP's
 that you may be able to fix.

On Tue, Aug 10, 2010 at 12:37 AM, A. James Lewis <james@fsck.co.uk> wro=
te:
> Not being one of the developers on this project, I cannot offer you a
> solution to recovering data from this volume, and my guess is that a
> ready solution is unlikely to be forthcoming simply because if this w=
as
> possible then btrfsck would include the code to recover the filesyste=
m
> already.
>
> However, rather than simply observe that anything not backed up is
> lost... I thought I would offer the solution of the 4th dimension....
> The data is not "lost", but simply unavailable to you until the tools=
 to
> repair the filesystem have been developed further. =A0If I had someth=
ing
> critical which had become inaccessible, I might be tempted to put the
> drive on a shelf for 6 months and see if btrfsck was able to repair
> filesystems by then. =A0It may be that the on disk format is changed
> before that happens, but I understand that this is now relatively
> unlikely.
>
> A. James Lewis
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
S.D.G.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
