From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Wed, 04 May 2011 15:33:28 -0400
Message-ID: <4DC1AA08.7000502@redhat.com>
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <16735.1304537498@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16735.1304537498@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2011 03:31 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 13:58:39 EDT, Josef Bacik said:
>
>> +#define SEEK_HOLE	3	/* seek to the closest hole */
>> +#define SEEK_DATA	4	/* seek to the closest data */
>
> Comments here need nearest/next fixing as well - otherwise the ext[34] crew may
> actually implement the commented semantics. ;)
>

Balls, thanks I'll fix that.

> Other than that, patch 1/2 looks OK to me (not that there's much code to
> review), and 2/2 *seems* sane and implement the "next" semantics, though I only
> examined the while/if structure and am assuming the btrfs innards are done
> correctly.  In particular, that 'while (1)' looks like it can be painful for a
> sufficiently large and fragmented file (think a gigabyte file in 4K chunks,
> producing a million extents), but I'll let a btrfs expert analyse that
> performance issue ;)
>

Heh well we do while (1) in btrfs _everywhere_, so this isn't anything 
new, tho I should probably throw a cond_resched() in there.  Thanks,

Josef
