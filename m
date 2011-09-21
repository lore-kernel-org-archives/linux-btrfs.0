From: David Sterba <dave@jikos.cz>
Subject: Re: Still can't access wiki for btrfs; anybody have a copy of the documentation & source?
Date: Thu, 22 Sep 2011 01:37:46 +0200
Message-ID: <20110921233746.GO22205@twin.jikos.cz>
References: <4E7A4AEE.6040903@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Anadon <joshua.r.marshall.1991@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E7A4AEE.6040903@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Sep 21, 2011 at 04:37:02PM -0400, Anadon wrote:
> I'm trying to look into working on some few features for a filesystem, 
> and figured that if they were to be adopted, better work on the current 
> project. I'm looking for the standard documentaion, and a copy of the 
> source.  I have no idea where to look for these since everything still 
> points to kernel.org, and as of this mailing, is still not accessible.

there's the google cache and web.archive.org but not every wiki page can
be found there (not to say the latest version).

from archive.org:

http://web.archive.org/web/20110720220640/https://btrfs.wiki.kernel.org/index.php/Main_Page
http://web.archive.org/web/20110720220320/https://btrfs.wiki.kernel.org/index.php/FAQ
http://web.archive.org/web/20110720220157/https://btrfs.wiki.kernel.org/index.php/Changelog
http://web.archive.org/web/20110720220106/https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
http://web.archive.org/web/20110720220351/https://btrfs.wiki.kernel.org/index.php/Btrfs_design
http://web.archive.org/web/20110720220543/https://btrfs.wiki.kernel.org/index.php/Multiple_Device_Support
http://web.archive.org/web/20110720222839/https://btrfs.wiki.kernel.org/index.php/Btrfs-convert

google cache:

Getting started
Debugging Btrfs with GDB
Btree Items
Btrfs-bcp
Code documentation

You may find documentation for your feature project, Linus' current git
sources can be cloned from https://github.com/torvalds/linux . Look at
urls in merge commits to find more git tree sources :)

If you want to start working on a feature for btrfs, just ask here,
somebody will speak up if it's already claimed.


david
