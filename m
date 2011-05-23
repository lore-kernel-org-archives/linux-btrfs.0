From: Omen Wild <omen+btrfs@mandarb.com>
Subject: Mixed RAID 1 and 0 in different subvolumes?
Date: Mon, 23 May 2011 13:06:21 -0700
Message-ID: <20110523200621.GA25362@mandarb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a way to mix RAID 1 and 0 in different subvolumes?  I am a new
user to btrfs and would like to protect the important files with
mirroring, but have a bulk area that is striped for speed and size.

For example I want / and /home to be mirrored, but /media can just be
striped as it is all data I can easily recreate.

I see an item in the Project_ideas wiki entry called "Online raid
config" which looks exactly like what I am after.  I know some of the
items in that list are being worked on.  Is anyone working on this one?

Thanks

-- 
T-Shirt saying: When everyone agrees with me, I know I'm wrong.
