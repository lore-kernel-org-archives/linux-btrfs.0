Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3JALTx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 07:19:53 -0400
Date: Tue, 1 Oct 2013 13:19:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] enhance btrfs qgroup show command
Message-ID: <20131001111950.GA18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 02:17:19PM +0800, Wang Shilong wrote:
> Firstly, we restructure show_qgroups, make it easy to add new features.
> And then we add '-p' '-c', '-l',and '-e' options to print the parent
> qgroup id, child qgroup id, max referenced size and max exclusive size
> of qgroup respectively, add '-F' and '-f' option to list qgroups that
> impact the given path.

Well done! I really like it.

Minor comments:

* -l sounds less intuitive, I suggest to use -r as for
  'referenced', given that there is -e for 'exclusive'.

* the size should be pretty-printed by default or in bytes if a
  commandline option is given

* in the long term, the tabular output would be much better as
  default, and the current terse output available via commandline option
  for batch processing

thanks,
david
