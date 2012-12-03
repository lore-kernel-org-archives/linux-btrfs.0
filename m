Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:36403 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2LCTdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 14:33:00 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so2455370iay.19
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2012 11:33:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BC92F6.6050404@petaramesh.org>
References: <50BC92F6.6050404@petaramesh.org>
Date: Mon, 3 Dec 2012 14:32:59 -0500
Message-ID: <CAAS2fgRF0gxjwDebc8Ezjv2gwbaCkoE8Ke7m+Ko0dN74m_FCqw@mail.gmail.com>
Subject: Re: Example of BTRFS uglyssima performance : Bitcoin
From: Gregory Maxwell <gmaxwell@gmail.com>
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 3, 2012 at 6:54 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> I assume it an SQL DB (SQlite or so ?)

It's BDB with a very pessimal random write workload updating
transaction indexes with stuffed full of sync writes, interspersed
with an equal amount of random reads.

(The next version of the software will change the backend in several
ways, including replacing BDB with leveldb and its orders of magnitude
faster;  but for now it's probably a fine FS abusive test case)
