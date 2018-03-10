Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36399 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbeCJFsF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 00:48:05 -0500
Received: by mail-lf0-f49.google.com with SMTP id e28-v6so7140379lfc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Mar 2018 21:48:04 -0800 (PST)
Subject: Re: Change of Ownership of the filesystem content when cloning a
 volume
To: "Saravanan Shanmugham (sarvi)" <sarvi@cisco.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <DD5148B6-42C8-4598-A1E5-D652C6CF10E1@cisco.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5c0915bb-96bf-00a5-53d9-c511de8ed4b3@gmail.com>
Date: Sat, 10 Mar 2018 08:48:02 +0300
MIME-Version: 1.0
In-Reply-To: <DD5148B6-42C8-4598-A1E5-D652C6CF10E1@cisco.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.03.2018 02:13, Saravanan Shanmugham (sarvi) пишет:
> 
> Netapp’s storage system, has the concept of snapshot/clones.
> And when I create a clone from a snapshot, I can give/change ownership of entire tree in the volume to a different userid.

You are probably mistaken. NetApp FlexClone (which you probably mean)
does not have any ways to change volume content. Of course you can now
mount this clone and do whatever you like from host, but that is
completely unrelated to NetApp itself and can just as well be done using
btrfs subvolume.

> 
> Is something like that possible in BTRFS?
> 
> We are looking to use CopyOnWrite to snapshot nightly build workspace and clone as developer workspaces to avoid building from scratch for developers,
> And move directly for incremental builds.
> For this we would like the clone workspace/volume to be instantly owned by the developer cloning the workspace.
> 
> Thanks,
> Sarvi
> -----
> Occam's Razor Rules
> 
> 
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{�n�߲)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 

