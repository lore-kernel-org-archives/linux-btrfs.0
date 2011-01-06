From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 6 Jan 2011 15:20:59 +0100
Message-ID: <20110106142059.GA13178@domone>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
 <4D24AD92.4070107@bobich.net>
 <ig4bur$mns$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ig4bur$mns$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 06, 2011 at 12:18:34PM +0000, Simon Farnsworth wrote:
> Gordan Bobic wrote:
> 
> > Josef Bacik wrote:
> > 
snip
 > 
> > Then again, for a lot of use-cases there are perhaps better ways to
> > achieve the targed goal than deduping on FS level, e.g. snapshotting or
> > something like fl-cow:
> > http://www.xmailserver.org/flcow.html
> > 
As VM are concerned fl-cow is poor replacement of deduping.

Upgrading packages? 1st vm upgrades and copies changed files.
After while second upgrades and copies files too. More and more becomes duped again.

If you host multiple distributions you need to translate
that /usr/share/bin/foo in foonux is /us/bin/bar in barux

And primary reason to dedupe is not to reduce space usage but to
improve caching. Why should machine A read file if machine B read it five minutes ago.
 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

user to computer ration too low.
