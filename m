From: Andrew Carlson <naclosagc@gmail.com>
Subject: Fix for rm -r
Date: Fri, 9 Apr 2010 13:14:32 -0500
Message-ID: <l2q6842966e1004091114kb6af53f1t6403a1a37e7c15a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The latest unstable git pull fixed a little problem I had with rm -r.
With a filled up filesystem, rm -rwould stop after a few minutes say
"filesystem full', but a subsequent rm -r would clear the filesystem.
Now, it acts as it should, and removed all the files and directories
the first time.

-- 
Andy Carlson
---------------------------------------------------------------------------
Gamecube:$150,PSO:$50,Broadband Adapter: $35, Hunters License: $8.95/month,
The feeling of seeing the red box with the item you want in it:Priceless.
