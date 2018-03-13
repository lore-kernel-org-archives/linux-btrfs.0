Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33156 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933034AbeCMNri (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 09:47:38 -0400
Received: by mail-wr0-f175.google.com with SMTP id r8so7725811wrg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 06:47:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com> <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com> <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io> <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
 <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Tue, 13 Mar 2018 14:47:17 +0100
Message-ID: <CAA7pwKOne96m-_i=uWfZ2dAkHwjxfe=9LaRa5NDd9+nWtYERGw@mail.gmail.com>
Subject: Re: Ongoing Btrfs stability issues
To: Alex Adriaanse <alex@oseberg.io>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 March 2018 at 20:05, Alex Adriaanse <alex@oseberg.io> wrote:
>
> Yes, we have PostgreSQL databases running these VMs that put a heavy I/O load on these machines.

Dump the databases and recreate them with --data-checksums and Btrfs
No_COW attribute.

You can add this to /etc/postgresql-common/createcluster.conf in
Debian/Ubuntu if you use pg_createcluster:
initdb_options = '--data-checksums'
