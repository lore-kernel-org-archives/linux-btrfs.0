From: Andrew Carlson <naclosagc@gmail.com>
Subject: btrfs-delalloc - threaded?
Date: Tue, 6 Sep 2011 11:21:26 -0500
Message-ID: <CALjZLS5iA1TVJCVWSpE+Xg5hG_E1c+LVrFz2EJK2b=Xc7MQw_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all.

I was doing some testing with writing out data to a BTFS filesystem
with the compress-force option.  With 1 program running, I saw
btfs-delalloc taking about 1 CPU worth of time, much as could be
expected.  I then started up 2 programs at the same time, writing data
to the BTRFS volume.  btrfs-delalloc still only used 1 CPU worth of
time.  Is btrfs-delalloc threaded, to where it can use more than 1 CPU
worth of time?  Is there a threshold where it would start using more
CPU?

Thanks for any information you can provide.

-- 
Andy Carlson
---------------------------------------------------------------------------
Gamecube:$150,PSO:$50,Broadband Adapter: $35, Hunters License: $8.95/month,
The feeling of seeing the red box with the item you want in it:Priceless.
