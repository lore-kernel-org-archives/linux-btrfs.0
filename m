From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: efficiency of btrfs cow
Date: Sun, 6 Mar 2011 23:02:47 +0700
Message-ID: <AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com>
References: <il0a8d$4ev$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <il0a8d$4ev$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 6, 2011 at 10:46 PM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> # cp -al /backup/previous-backup/ /backup/current-backup
> # rsync -aAHX ... --exclude /backup / /backup/current-backup
>
> The shortcoming of this of course is that it just takes 1 byte in a
> (possibly huge) file to require that the whole file be recopied to the
> backup.

If you have snapshots anyway, why not :
- create a snapshot before each backup run
- use the same directory (e.g. just /backup), no need to "cp" anything
- add "--inplace" to rsync

-- 
Fajar
