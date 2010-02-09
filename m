From: Chris Ball <cjb@laptop.org>
Subject: Re: [bug] Reclaim space.
Date: Tue, 09 Feb 2010 16:17:58 -0500
Message-ID: <m31vgu2jnd.fsf@pullcord.laptop.org>
References: <1265740911.5943.7.camel@pi> <m3iqa62n8t.fsf@pullcord.laptop.org>
	<m3d40e2kdn.fsf@pullcord.laptop.org> <1265749549.5943.8.camel@pi>
	<m38wb22k5m.fsf@pullcord.laptop.org> <1265750019.5943.9.camel@pi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: pomac@vapor.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265750019.5943.9.camel@pi> (Ian Kumlien's message of "Tue, 09
	Feb 2010 22:13:39 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > btrfsctl -D ext2_saved/
   > ioctl:: Invalid argument

It's merged (during 2.6.32) -- I think you just have the wrong syntax.
See http://btrfs.wiki.kernel.org/index.php/Btrfsctl.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
