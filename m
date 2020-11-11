Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95508C388F7
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Nov 2020 01:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 304BF216C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Nov 2020 01:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dxuuu.xyz header.i=@dxuuu.xyz header.b="MvAevh5w";
	dkim=temperror (0-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IIj4oEAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732488AbgKKBhV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 20:37:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47049 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732319AbgKKBhU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Nov 2020 20:37:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 16B4F5C0285;
        Tue, 10 Nov 2020 20:37:20 -0500 (EST)
Received: from imap35 ([10.202.2.85])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 20:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm2; bh=VTxEIZW+GDHUUeUy49EwGX4CYtB1U+a
        Lsm+Rzse245E=; b=MvAevh5wBcvDXqfdyROogZHYaEQDCrTvCurUZfZn7NsuoP0
        f1nb+T/3GMd/KOgoVtn+3NQFU8IV82YOhVUk+ZcP+54YzOiJm5wm3xa1507EIKLm
        sL0BaNEkTmNC2kuiNyuSD4jJDpk3BgZ4E8v06CatN7jcT8I9l24j4qA3skrtrOy8
        J+5HKx1EWZz9NucFS7hilB2bC1sYZZpMXiSQKHgUVXUUgi0STufOV7fqPEAC9AlR
        SZxvXNUscgVolHsQGySK+VZujIFKiVsVdfPbwN48YalLhkVKhY3ZWgMS79esaq8c
        PIMYAwGDd+nhiWbfxZCyTAMTtiTS1uSRyYKBL8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VTxEIZ
        W+GDHUUeUy49EwGX4CYtB1U+aLsm+Rzse245E=; b=IIj4oEATofw3WRBlPncD0w
        H90+h+y108hbocXUs7oV9/x8eX6r+Z0vK6U07IvC1yoFzlMc7YV22bVEdXoM5Y4Q
        xNcA7IhBhe12+Zl5MZas4B9yygx4F60iT0qWRTgBQOSgesOfsJDbfmOjC47/Sypc
        ak+2hUgdYgWmhMaN4jnUA57JN2aChbIem9h6QYLzat/pQsnjBCawWTKPYiXLD3XD
        7UGktr+y8AMAsY1ETHPzvI0Jb+6cbpl4pzcqRqNEXljMmqVY2z8osQ8X+WPva0Lu
        m2H2XPRJWEAL+IHVIDkdFUJKuFMSnGICHKdiZ3YO4HPqJt5lRIFfmK32EwFWDzjw
        ==
X-ME-Sender: <xms:T0CrX5jF2lLOHsE-lF9EW7spcUJHq2gBYAWkLGqft0Fm_bhkeTgp3w>
    <xme:T0CrX-DNwhTgJuDuvewEX0a0_sXNmqt8wI7c53tnUzy7i1numZRmauKfNQ0dtwla6
    HUA5scGfiUXlv2saQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduledgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpefofgggkfgjfhffhffvufgtsehttdertder
    redtnecuhfhrohhmpedfffgrnhhivghlucgiuhdfuceougiguhesugiguhhuuhdrgiihii
    eqnecuggftrfgrthhtvghrnhepveduvefhtefhvdfhjeffhffhtefhlefhieevieeiudfg
    jeeufedukeetjeekveefnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhu
    rdighiii
X-ME-Proxy: <xmx:T0CrX5FAyd0jhwuxDDBGiL0uH-6MNX2ZYCZh1U4V9kd23J1eiAyVmQ>
    <xmx:T0CrX-QvQscw35deQaasdQn2ol4TXeWYEMDS51gAmVKsf5AjE2NlJQ>
    <xmx:T0CrX2wAqWgjtW2q5_n61JjlovUzGQ3YJQ2imRsEohHDtcoVdedeVw>
    <xmx:UECrX7rTkW4vNBWPmEDoIl0b7u36Jhf5_FvrMweSKZVeYzQtJrBdyQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A3A5A14C00BD; Tue, 10 Nov 2020 20:37:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-570-gba0a262-fm-20201106.001-gba0a2623
Mime-Version: 1.0
Message-Id: <ee82ab2e-2464-406e-af3f-732874714869@www.fastmail.com>
In-Reply-To: <f4cf625aa2a0e52f722c7e1e92dc04906e1049dc.1604014245.git.dxu@dxuuu.xyz>
References: <f4cf625aa2a0e52f722c7e1e92dc04906e1049dc.1604014245.git.dxu@dxuuu.xyz>
Date:   Tue, 10 Nov 2020 17:36:59 -0800
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        "Josef Bacik" <josef@toxicpanda.com>
Cc:     "Kernel Team" <kernel-team@fb.com>
Subject: Re: [PATCH v2] btrfs-progs: restore: Have -l display subvolume name
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 29, 2020, at 4:33 PM, Daniel Xu wrote:
> This commit has `btrfs restore -l ...` display subvolume names if
> applicable. Before, it only listed subvolume IDs which are not very
> helpful for the user. A subvolume name is much more descriptive.
> 
> Before:
> 	$ btrfs restore ~/scratch/btrfs/fs -l
> 	 tree key (EXTENT_TREE ROOT_ITEM 0) 30425088 level 0
> 	 tree key (DEV_TREE ROOT_ITEM 0) 30441472 level 0
> 	 tree key (FS_TREE ROOT_ITEM 0) 30736384 level 0
> 	 tree key (CSUM_TREE ROOT_ITEM 0) 30474240 level 0
> 	 tree key (UUID_TREE ROOT_ITEM 0) 30785536 level 0
> 	 tree key (256 ROOT_ITEM 0) 30818304 level 0
> 	 tree key (257 ROOT_ITEM 0) 30883840 level 0
> 	 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 30490624 level 0
> 
> After:
> 	$ ./btrfs restore ~/scratch/btrfs/fs -l
> 	 tree key (EXTENT_TREE ROOT_ITEM 0) 30425088 level 0
> 	 tree key (DEV_TREE ROOT_ITEM 0) 30441472 level 0
> 	 tree key (FS_TREE ROOT_ITEM 0) 30736384 level 0
> 	 tree key (CSUM_TREE ROOT_ITEM 0) 30474240 level 0
> 	 tree key (UUID_TREE ROOT_ITEM 0) 30785536 level 0
> 	 tree key (256 ROOT_ITEM 0) 30818304 level 0 subvol1
> 	 tree key (257 ROOT_ITEM 0) 30883840 level 0 subvol2
> 	 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 30490624 level 0
> 
> Link: https://github.com/kdave/btrfs-progs/issues/289
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
> v1 -> v2:
> * moved get_subvol_name() to common/utils.c
> * check return from get_subvol_name() for errors
> 
>  cmds/restore.c | 14 +++++++++++++-
>  common/utils.c | 35 +++++++++++++++++++++++++++++++++++
>  common/utils.h |  1 +
>  3 files changed, 49 insertions(+), 1 deletion(-)
> 
[...]

Ping
