Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65015 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190Ab2KAWQI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 18:16:08 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2023868pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 15:16:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
Date: Thu, 1 Nov 2012 16:16:07 -0600
Message-ID: <CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com>
Subject: Re: [Request for review] [RFC] Add label support for snapshots and subvols
From: cwillu <cwillu@cwillu.com>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Below is a demo of this new feature.
> ------------
>  btrfs fi label -t /btrfs/sv1 "Prod-DB"
>
>  btrfs fi label -t /btrfs/sv1
> Prod-DB
>
>  btrfs su snap /btrfs/sv1 /btrfs/snap1-sv1
> Create a snapshot of '/btrfs/sv1' in '/btrfs/snap1-sv1'
>  btrfs fi label -t /btrfs/snap1-sv1
>
>  btrfs fi label -t /btrfs/snap1-sv1 "Prod-DB-sand-box-testing"
>
>  btrfs fi label -t /btrfs/snap1-sv1
> Prod-DB-sand-box-testing

Why is this better than:

# btrfs su snap /btrfs/Prod-DB /btrfs/Prod-DB-sand-box-testing
# mv /btrfs/Prod-DB-sand-box-testing /btrfs/Prod-DB-production-test
# ls /btrfs/
Prod-DB  Prod-DB-production-test
