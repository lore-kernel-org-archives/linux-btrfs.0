From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: fstrim on BTRFS
Date: Wed, 28 Dec 2011 17:57:15 +0100
Message-ID: <201112281757.16019.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

With 3.2-rc4 (probably earlier), Ext4 seems to remember what areas it 
trimmed:

merkaba:~> fstrim -v /boot
/boot: 224657408 bytes were trimmed
merkaba:~> fstrim -v /boot
/boot: 0 bytes were trimmed


But BTRFS does not:

merkaba:~> fstrim -v /
/: 4431613952 bytes were trimmed
merkaba:~> fstrim -v /    
/: 4341846016 bytes were trimmed


Is it planned to add this feature to BTRFS as well?


I wish you a relaxed between Christmas and new year time,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
