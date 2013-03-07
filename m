Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40571 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab3CGSGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 13:06:48 -0500
Received: by mail-vc0-f175.google.com with SMTP id p1so423741vcq.20
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 10:06:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5138B08F.70607@petaramesh.org>
References: <513883DD.8080203@petaramesh.org>
	<5138980C.8080000@redhat.com>
	<5138ADA6.5070101@petaramesh.org>
	<5138AE96.3020304@redhat.com>
	<5138B08F.70607@petaramesh.org>
Date: Thu, 7 Mar 2013 13:06:47 -0500
Message-ID: <CALJXSJrbF678ghk63P=m2wc5NGnRjrvk2cGMqSnKHXzXG+i3Tg@mail.gmail.com>
Subject: Re: mkfs.btrfs broken
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        Anand Jain <Anand.Jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 7, 2013 at 10:21 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> lstat64("/sqfs_disk", 0xbff57820)       = -1 ENOENT (No such file or
> directory)

mkfs.btrfs tries to lookup loop devices by their filenames and fails
if any loop device file is missing.
