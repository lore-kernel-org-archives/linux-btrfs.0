Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60783 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaJBFFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 01:05:40 -0400
Received: by mail-ie0-f178.google.com with SMTP id rl12so1798593iec.37
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Oct 2014 22:05:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKZK7uzNJWSQAmaem4eZj-dcSJOvmT=-Mn53rjCbb=fNY9zEhw@mail.gmail.com>
References: <CAKZK7uzNJWSQAmaem4eZj-dcSJOvmT=-Mn53rjCbb=fNY9zEhw@mail.gmail.com>
Date: Thu, 2 Oct 2014 00:05:39 -0500
Message-ID: <CAKZK7uwWDQa_7LThjW_58+DpNQogkepuwvPhg-9bzsgyQjn14Q@mail.gmail.com>
Subject: Fwd: Deleting a Subvol from a Cancelled Btrfs-Send
From: Justin Brown <justin.brown@fandingo.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm experimenting with btrfs-send. Previously (2014-09-26), I did my
first btrfs-send on a subvol, and that worked fine. Today, I tried to
send a new snapshot. Unfortunately, I realized part way through that I
forgot to specify the parent to only send a delta, and killed the send
with ^C.

On the destination, I'm left with:

~$ sudo btrfs subvol list /var/media/backups/venus/home/
ID 2820 gen 57717 top level 5 path media
ID 2821 gen 57402 top level 5 path ovirt
ID 4169 gen 57703 top level 2820 path media/backups/venus/home
ID 4170 gen 57575 top level 4169 path home-2014-09-26
ID 4243 gen 57707 top level 4169 path home-2014-10-01

Home-2014-10-01 was the partial send that was cancelled. I figured
that I could delete this partial subvol and try again.

~$ sudo btrfs subvol del home-2014-10-01
Transaction commit: none (default)
ERROR: error accessing 'home-2014-10-01'

Obviously, trying to delete the subvol directory fails too:

~$ sudo rm -rf /var/media/backups/venus/home/home-2014-10-01/
rm: cannot remove ‘/var/media/backups/venus/home/home-2014-10-01/’:
Operation not permitted

Is there anyway to delete this partial subvol?

Thanks,
Justin
