Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3CAKgc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 05:36:32 -0500
Message-ID: <513084A4.1050607@oracle.com>
Date: Fri, 01 Mar 2013 18:36:20 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] Btrfs: ability to add label to snapshot and subvol
References: <1361770305-1206-1-git-send-email-anand.jain@oracle.com> <1361770305-1206-2-git-send-email-anand.jain@oracle.com> <20130225204523.GK14283@carfax.org.uk>
In-Reply-To: <20130225204523.GK14283@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  As long as we integrate, broadcast and use single
  keyword for a purpose I am fine with using xattr.
  Patch using xattr was posted as well.

  Just a note, potential applications using snapshot
  label are:
    - Yum, btrfs-progs, snapper, btrfs-gui,
    Gnome-Nautilus-snapshot-plugin,
    enterprise backup-scripts, PHP-scripts using MYsql.


>     As long as there's a well-known xattr name that's written by
> btrfs-progs, that'll become the de-facto standard. If any other system
> fails to use that attribute name, it becomes non-interoperable with
> the default tools. This is probably enough to ensure that it'll get
> fixed fairly quickly in this case (because the users that care about
> the feature will complain it's not working right).
>
>     My conclusion: go with user xattrs.


Thanks.

  Any comment on the patch titled
    Btrfs-progs: add attribute label for subvol and snapshot

will help integration.

-Anand
