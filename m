Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41326 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab3EERmh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 13:42:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZ2xA-0004Za-Dc
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 19:42:28 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 19:42:28 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 19:42:28 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Script for creating/managing snapshots of all subvolumes of all filesystems
Date: Sun, 05 May 2013 19:36:18 +0200
Message-ID: <fthi5a-o7r.ln1@hurikhan.ath.cx>
References: <loom.20130503T133254-992@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Skwar <alexanders.mailinglists+nospam@gmail.com> schrieb:

> FWIW, I've also written a script which creates and "manages"
> (ie. deletes old) snapshots.
> 
> It figures out all the available filesystems and creates snaps
> for all the available (sub)volumes.
> 
> It's also on https://copy.com/WI9AXqTH2nD4 and
> http://pastebin.com/YX8WKcsR to avoid line break issues and also with
> comments.

You should change the calls of "btrfs subv del" etc to use unabbreviated 
versions of the commands. Otherwise you expose your script to erratic 
behavior as soon as new commands are added to btrfs that make your usage of 
the commands ambigious.

Regards,
Kai

