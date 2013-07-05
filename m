Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59750 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3GEWLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 18:11:49 -0400
Date: Fri, 5 Jul 2013 16:41:00 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130705204100.GA15943@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1370280485-10047-1-git-send-email-joern@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 3 June 2013 13:28:03 -0400, Joern Engel wrote:
> 
> A purely janitorial patchset.  A fairly common pattern is to take a
> list, remove every object from it and do something with this object -
> usually kfree() some variant.  A stupid grep identified roughly 300
> instances, with many more hidden behind more complicated patterns to
> achieve the same end results.

Next version of the same patchset.  Object size is shrinking now, at
least for the one compiler I tested.  And a few kernel hackers met on
a frozen lake in hell with pigs flying overhead and could actually
agree on a name.  While I am sure almost every reader will still
disagree and have one or two better suggestions, I would like to use
this historical moment.

list_del_each and list_del_each_entry is shall be!

Jörn

--
It's just what we asked for, but not what we want!
-- anonymous
