From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Wed, 9 May 2012 19:18:07 +0200
Message-ID: <20120509171807.GO19331@twin.jikos.cz>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
 <2913005.FpWZk4H159@bursa01>
 <20120502173629.GI6740@twin.jikos.cz>
 <1405178.Vd8v8qs4AD@bursa01>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1405178.Vd8v8qs4AD@bursa01>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2012 at 03:11:45PM +0200, Hubert Kario wrote:
> nice, didn't know about this. Such functionality would be nice to have.
> But then I don't think that a "recreate the array if the parameters are the 
> same" is actually a good idea, lots of space for error. A pair of functions:
> 
> btrfs dev zero-superblock
> btrfs dev restore-superblock

As a user, I'm not sure what can I expect from the restore command. From
where does it restore? Eg. a file?

As a tester I have use for a temporary clearing of a superblock on a
device, then mount it with -o degraded, work work, and then undo
clearing. So, my idea is like

  btrfs device zero-superblock --undo

with the obvious sanity checks. A regular user would never need to call
this.


david
