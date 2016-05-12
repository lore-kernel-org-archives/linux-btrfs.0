Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:41009 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbcELGHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 02:07:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 12 May 2016 15:07:42 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: 4.4.0 - no space left with >1.7 TB free space left
In-Reply-To: <ba2a8fca73f02c328d94d541ff53a94b@admin.virtall.com>
References: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
 <20160208162410.58cb2b4a@natsu>
 <eaeffce90cd04fa5b91284ca580b5969@admin.virtall.com>
 <20160408165332.450659c4@natsu>
 <ba2a8fca73f02c328d94d541ff53a94b@admin.virtall.com>
Message-ID: <69602a61b406a48ccdc6cc8d5293e639@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-12 15:03, Tomasz Chmielewski wrote:

> FYI, I'm still getting this with 4.5.3, which probably means the fix
> was not yet included ("No space left" at snapshot time):
> 
> /var/log/postgresql/postgresql-9.3-main.log:2016-05-11 06:06:10 UTC
> LOG:  could not close temporary statistics file
> "pg_stat_tmp/db_0.tmp": No space left on device
> /var/log/postgresql/postgresql-9.3-main.log:2016-05-11 06:06:10 UTC
> LOG:  could not close temporary statistics file
> "pg_stat_tmp/global.tmp": No space left on device
> /var/log/postgresql/postgresql-9.3-main.log:2016-05-11 06:06:10 UTC
> LOG:  could not close temporary statistics file
> "pg_stat_tmp/db_0.tmp": No space left on device
> /var/log/postgresql/postgresql-9.3-main.log:2016-05-11 06:06:10 UTC
> LOG:  could not close temporary statistics file
> "pg_stat_tmp/global.tmp": No space left on device
> 
> 
> I've tried mounting with space_cache=v2, but it didn't help.

On the good side, I see it's in 4.6-rc7.


Tomasz Chmielewski
http://wpkg.org

