From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Btrfs features/stabilisation timeline?
Date: Tue, 6 Apr 2010 20:09:27 +0200 (CEST)
Message-ID: <23688472.10.1270577367897.JavaMail.root@zimbra>
References: <21598622.8.1270576917138.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <21598622.8.1270576917138.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

With Sun^WOracle's changes to the Solaris license and more, Btrfs looks more welcome every day. However, I can't find anything about its progress for stabilisation or features, so I guess it miht be appropriate to ask here?

* How far is Btrfs to become "stable" as in for production use?
* I think I read a year back that RAID[56] support was started (merge of md code IIRC). How far has this come? Will it allow for what ZFS RAIDZ[123] can do?
* In ZFS, block sizes vary depending on file size on the same filesystem. Is this a feature that is wanted or that will (or is) included in Btrfs?
* In ZFS, some dedup has been added. I read somewhere this is a planned feature in Btrfs, but again, is it far away?
* ZFS is self-healing for device failures or sector errors, given sufficient redundancy with mirrors or raidz[123]. I guess this will the same in Btrfs?
* in ZFS, scrubbing takes up a very high amount of I/O, significantly reducing disk performance for the zpool (at least this is the case for 2009.06 and Solaris 10). Will there be done efforts to help avoding this with Btrfs?

Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
