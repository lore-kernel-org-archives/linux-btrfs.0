From: =?UTF-8?Q?Rodrigo_E=2E_De_Le=C3=B3n_Plicet?= <rdeleonp@gmail.com>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Wed, 30 Jun 2010 22:38:18 -0500
Message-ID: <AANLkTimVLjQfRjJFeHVI0NLEEE64iYtqLqYvZUQ6X_B7@mail.gmail.com>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
	<20100602155646.GA4041@flcl.lan> <loom.20100628T154422-48@post.gmane.org>
	<AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com>
	<87eifov564.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Daniel Kozlowski <dan.kozlowski@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87eifov564.fsf@mid.deneb.enyo.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 30, 2010 at 11:47 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> ZFS doesn't need a fsck because you have throw away the file system
> and restore from backup for certain types of corruption:
>
> | What can I do if ZFS file system panics on every boot?
> [...]
> | This will remove all knowledge of pools from your system. You will
> | have to re-create your pool and restore from backup.
>
> <http://hub.opensolaris.org/bin/view/Community+Group+zfs/faq#HWhatcanIdoifZFSfilesystempanicsoneveryboot>


They *do* make it clear when could something like that happen.

>From the same URL:

"ZFS is designed to survive arbitrary hardware failures through the
use of redundancy (mirroring or RAID-Z). Unfortunately, certain
failures in *non-replicated* configurations can cause ZFS to panic
when trying to load the pool. This is a bug, and will be fixed in the
near future (along with several other nifty features, such as
background scrubbing)."

"Non-replicated configuration" boils down to no mirroring or parity
checking (basically RAID-0 or similar); such a thing implies:

- No redundancy.
- No fault tolerance.

So, yeah, I guess if you go for a "non-replicated configuration",
there will be risks, whether you use ZFS, btrfs,
MD+LVM+$ANY_TRADITIONAL_FS, etc.
