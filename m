From: David Nicol <davidnicol@gmail.com>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 15:48:42 -0500
Message-ID: <AANLkTindV2+jL3XTP+7Um_156BMzY5eqRd4iucrVhPo-@mail.gmail.com>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Francis Galiegue <fgaliegue@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 7, 2010 at 6:39 AM, Francis Galiegue <fgaliegue@gmail.com> wrote:
> While I fully understand (and use) the purpose of snapshots, I don't
> quite fathom the use case for subvolumes, apart from btrfs-convert...
> Why has btrfs grown such a feature in the first place? Can someone
> give me a use case for them?

I'm new here; I trust that someone will correct me if wrong:

As I understand it, since snapshotting works on volumes, having
subvolumes allows a smaller thing that you can take a snapshot of. A
use case? One could give each user on a multi-user system their own
subvolume rather than their own directory, under /home/... and then
take snapshots of these home directories to implement regular backups
(1)without duplicating unchanged files and (2) with independence
between the users.

As to why they exist, I understand that they began as an
implementation detail of snapshots, rather than their creation having
been driven by the needs of a particular use case, and one could
legitimately criticize currently offered use cases (such as the one
above) as contrived.

I believe it is fair to consider a new subvolume as equivalent of a
snapshot of an empty file system.
