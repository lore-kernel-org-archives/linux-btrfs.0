Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41425 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbcK3PVe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 10:21:34 -0500
Date: Wed, 30 Nov 2016 16:21:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Harinath Nampally <harinath922@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Minor coverity defect fix - CID 1125928 In
 set_file_xattrs: Dereference of an explicit null value
Message-ID: <20161130152128.GP12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1479258473-30053-1-git-send-email-harinath922@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479258473-30053-1-git-send-email-harinath922@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this patch lacks basic formatting requirements, this has been
extensively documented eg. here https://btrfs.wiki.kernel.org/index.php/Developer's_FAQ .

Besides the formalities, I'm missing what's the change rationale. It
deals with a strange case when the xattr name length is 0, which is
unexpected and should not be handled silently. Next I'm not sure if
bailing out of the function is right, there are more items to process.
Best if we could skip the damaged ones but still continue.
