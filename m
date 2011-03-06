From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: efficiency of btrfs cow
Date: Sun, 06 Mar 2011 11:17:26 -0500
Message-ID: <1299428248.15017.13.camel@ayu>
References: <il0a8d$4ev$1@dough.gmane.org>
	 <AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Brian J. Murrell" <brian@interlinx.bc.ca>,
	linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2011-03-06 at 23:02 +0700, Fajar A. Nugraha wrote:
> On Sun, Mar 6, 2011 at 10:46 PM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> > # cp -al /backup/previous-backup/ /backup/current-backup
> > # rsync -aAHX ... --exclude /backup / /backup/current-backup
> >
> > The shortcoming of this of course is that it just takes 1 byte in a
> > (possibly huge) file to require that the whole file be recopied to the
> > backup.
> 
> If you have snapshots anyway, why not :
> - create a snapshot before each backup run
> - use the same directory (e.g. just /backup), no need to "cp" anything
> - add "--inplace" to rsync

To add a bit to this: if you *do not* use the --inplace option on rsync,
rsync will rewrite the entire file, instead of updating the existing
file!
This of course negates some of the benefits of btrfs's COW support when
doing incremental backups.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

