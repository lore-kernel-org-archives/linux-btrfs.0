From: member graysky <graysky@archlinux.us>
Subject: btrfsck integration with userlevel API for fsck
Date: Thu, 29 Mar 2012 18:08:16 -0400
Message-ID: <CAO_nJAbXsqU+dnZaEME-OjC-4Y8jZ5HhtyGV24BgFebPMhCW=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Are there plans to integrate btrfsck with the userlevel API for fsck?
AFAIK, it currently does not work as such (i.e. `shutdown -rF now`
does not trigger a check on the next boot).  What is the recommended
method to check a btrfs root filesystem?  Live media?
