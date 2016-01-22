Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34535 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbcAVEkq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 23:40:46 -0500
Received: by mail-io0-f170.google.com with SMTP id 1so76960753ion.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 20:40:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A1A84A.2020801@oracle.com>
References: <56A13176.2050502@gmail.com>
	<56A1A84A.2020801@oracle.com>
Date: Thu, 21 Jan 2016 21:40:45 -0700
Message-ID: <CAJCQCtTn8KvDRCD2h9aKBaWzYDLJpK6zE-f9AuDcD8zH4+Q_Tg@mail.gmail.com>
Subject: Re: "Some devices missing" only while not mounted
From: Chris Murphy <lists@colorremedies.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Konstantin Svist <fry.kun@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 8:55 PM, Anand Jain <anand.jain@oracle.com> wrote:

>   'btrfs dev ready':
>      - cannot be fixed without breaking the API rules.
>      May be we would obsolete this cli to a sysfs interface or
>      something else.


Wait, so 'btrfs dev ready' will always exit 1 (not ready) any time a
device has been made missing or replaced?  And therefore now the
system can't boot anymore since udev+systemd won't mount a Btrfs root
fs that's not ready? That's kindof a nasty bug.


-- 
Chris Murphy
