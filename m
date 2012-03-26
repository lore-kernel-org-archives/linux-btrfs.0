From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs and backups
Date: Mon, 26 Mar 2012 16:01:54 +0700
Message-ID: <CAG1y0scd6L75=m=en1+52gATpYKvvzo55E5PvxNcbqfuy7uCDg@mail.gmail.com>
References: <CAAMvbhFkaz7_N99D3Gu0WcBPKF2oTdaEfZXQDsUE1fRgSi5msw@mail.gmail.com>
	<4F702F54.90300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: James Courtier-Dutton <james.dutton@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F702F54.90300@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2012 at 3:56 PM, Felix Blanke <felixblanke@gmail.com> wrote:
> On 3/26/12 10:30 AM, James Courtier-Dutton wrote:
>> Is there some tool like rsync that I could copy all the data and
>> snapshots to a backup system, but still only use the same amount of
>> space as the source filesystem.


> I'm not sure if I understand your problem right, but I would suggest:
>
> 1) Snapshot the subvolume on the source
> 2) rsync the snapshot to the destination
> 3) Snapshot the destination

James did say "only use the same amount of space as the source
filesystem." Your approach would increase the usage when one or more
subvolume shares the same space (e.g. when one subvolume starts as
snapshot).

AFAIK the (planned) way to do this is using "btrfs send | receive",
which is not available yet.

-- 
Fajar
