Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60406 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933412Ab2KEW5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 17:57:19 -0500
Date: Mon, 5 Nov 2012 23:57:16 +0100
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs defrag problem
Message-ID: <20121105225716.GO3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <508FBE50.6070300@gmail.com>
 <20121031004027.GE3102@twin.jikos.cz>
 <50919550.3090800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50919550.3090800@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 01, 2012 at 05:17:04AM +0800, ching wrote:
> >> 3. Is any possible to online defrag a btrfs partition without hindered by mount point/polyinstantied directories?
> > Sorry, I do not understand the question.
> 
> when a device is mounted under a directory, files in the directory is "hidden", and files in the device is "available", right?
> when a directory is polyinstantied, files in the original directory is "hidden", and files in the polyinstantied directory is "available",
> 
> How to get past them and pass those "hidden" files to defrag command?

I hope I get it right, so unless you have a reference to the directory
with hidden files (using your term), there's no way to access them. And
this is a more generic question, not related to btrfs itself. The hidden
files may also belong to a different filesystem.

david
