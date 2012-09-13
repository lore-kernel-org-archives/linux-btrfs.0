Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65505 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2IMGKm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 02:10:42 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3971425obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 23:10:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACHiF8CwqRDkNeDTaDGb_jMJru1_Vn0AJ0_bqg74P7C92TzvJQ@mail.gmail.com>
References: <CACHiF8CwqRDkNeDTaDGb_jMJru1_Vn0AJ0_bqg74P7C92TzvJQ@mail.gmail.com>
Date: Thu, 13 Sep 2012 13:10:42 +0700
Message-ID: <CAG1y0scmYrR_ZJJwK839GzUsDA0t1BUHe=m7ePHDUhwjz9SHKQ@mail.gmail.com>
Subject: Re: specify UUID for btrfs
From: "Fajar A. Nugraha" <list@fajar.net>
To: ching lu <lsching17@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2012 at 1:07 PM, ching lu <lsching17@gmail.com> wrote:
> Is it possible to specify UUID for btrfs when creating the filesystem?

Not that I know of

> or changing it when it is offline?

This one is a definite no.

> i have several script/setting file which have hardcoded UUID and i do
> not want to update them every time when restore backup.

Using label would probably make more sense for that purpose. It can be
set and changed later.

-- 
Fajar
