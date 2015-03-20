Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:33152 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbCTCPg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 22:15:36 -0400
Received: by ykek76 with SMTP id k76so36319083yke.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 19:15:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550B7CAC.6030005@comcast.net>
References: <550B5C63.6010401@comcast.net>
	<CAJCQCtRj6MWc=YzvEepjiZTQYrN7CKbO0EivotZNjS218Gz56Q@mail.gmail.com>
	<550B7CAC.6030005@comcast.net>
Date: Thu, 19 Mar 2015 20:15:35 -0600
Message-ID: <CAJCQCtTO89u8203U+Oc_eyUbEDrT4YZU8xf1gG6omGWS0ehhSQ@mail.gmail.com>
Subject: Re: nube trying to backup my systems
From: Chris Murphy <lists@colorremedies.com>
To: don fisher <hdf3@comcast.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 7:49 PM, don fisher <hdf3@comcast.net> wrote:
> My rot
> is mounted at /usr11. I tried:
>
> UUID=26d63d99-92f4-4a49-878b-236f5e88af69 /usr11/srv btrfs
> subvol=usr11/srv       0 0
>
> but /usr11/srv did not mount. I replaced the number and it did mount. Would
> like to use string like you suggested since they are more understandable. Do
> you see what I did wrong?

Use 'btrfs subvolume list -a' like I suggested and use that path minus
any leading /. Chances are the path to the subvolume srv is just srv,
in which case it should be subvol=srv

>Any thoughts on stability of the IDs across boots?

They're completely reliable between reboots and renames. They're
assigned at creation, and either btrfs sub create or btfs sub snap
creates subvolumes.


-- 
Chris Murphy
