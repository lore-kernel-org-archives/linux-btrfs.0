Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5269CA0FE9
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Sep 2023 12:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347407AbjIAM4F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 08:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjIAM4E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2023 08:56:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68588E0
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Sep 2023 05:55:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 296EC1F45F
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Sep 2023 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693572957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=t+UHjQ00vVEgS93i8AixmfnfBI8aRI01bVep8Nm0kpU=;
        b=RbYlFt7vNNwCBHNodsZcURg3CKWxc+9f8Hrjz5/lBJYlhdTDuayZS8AOepfD0FMkeCmjxr
        3hKX+K/DRocYKG/7M6ejseXNkndDnNaqtjTX7EgrohKRqkrfb0vWsgr6SSzGYoFZPP+TB+
        eyejU7zcX3RoG02DabWyks0OxNqeMck=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 227DF2C142
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Sep 2023 12:55:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E36EBDA8A7; Fri,  1 Sep 2023 14:49:20 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 6.5
Date:   Fri,  1 Sep 2023 14:49:19 +0200
Message-ID: <20230901124920.25448-1-dsterba@suse.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 6.5 have been released. Note, version 6.4 has been skipped.

Changelog:

   * crc32c implementation speedup (3x)
   * btrfstune:
      * be more strict about option combinations and refuse changing
        features from incompatible groups
      * metadata_uuid changes fixes
   * libbtrfs: fix ABI breakage introduced in 6.3.1, revert struct subvol_info
     and subvol_uuid_search changes
   * CI updates
      * pull request build tests enabled
      * published static binaries built with backward compatibility (-march=x86-64)
   * other
      * documentation updates
      * new and updated tests
      * experimental feature updates (json, list-chunks, checksum switch)
      * code refactoring
      * remove btrfs-fragments

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
Release: https://github.com/kdave/btrfs-progs/releases/tag/v6.5
