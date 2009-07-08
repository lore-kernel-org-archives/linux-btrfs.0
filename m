From: "Tomasz Chmielewski" <mangoo@wpkg.org>
Subject: forcing compression?
Date: Wed, 8 Jul 2009 14:52:18 +0200
Message-ID: <3282b2992a72371c601e920ea30bec33.squirrel@ssl.syneticon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Right now, btrfs will decide on its own if the file is compressible or now.

It mostly works fine, but such detection will fail i.e. in case of disk images, where one may explicitly want to make sure the compression is used.


Is there a way to force compression?

# chattr +c disk.img
chattr: Operation not supported while setting flags on disk.img


-- 
Tomasz Chmielewski
http://wpkg.org



