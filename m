Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbbBJNa5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 08:30:57 -0500
Date: Tue, 10 Feb 2015 14:30:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: fsck-test: Add check_sudo to check valid
 root/sudo privilege
Message-ID: <20150210133055.GA28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423462312-4239-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423462312-4239-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 02:11:52PM +0800, Qu Wenruo wrote:
> Although fsck-test/012 uses sudo, it uses 'sudo -n', which won't prompt
> user to input password and will return 1 if no valid credential is
> found.
> 
> And this makes test result quite annoying since it fails to mount and
> still continue, which will always fail.
> 
> This patch introduced the new check_sudo() to check sudo before calling
> $sudo. This function will check "sudo -v -n" to get the credential.
> And if it fails, then the test will not be run.

This logic is fine, but the setup fails for me even if typing the
password is not required. I think the 'sudo -v' check is wrong as it
tries to refresh the credentials.

  $ sudo -v -n
  sudo: a password is required

while

  $ sudo -n /bin/true

works.
