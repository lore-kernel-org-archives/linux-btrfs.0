Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADEBC25B48
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Oct 2023 05:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjJ0Fog (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 01:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjJ0Fof (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2023 01:44:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB321A7;
        Thu, 26 Oct 2023 22:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tJIaOwEddcdYLTVKEZH1EeDVU5DzYIlN4t/E6prxOjk=; b=VbVJvjE0VhdfX/aZ23V+vUXiX7
        AHkXChdvSiIlFUCGKayf3ZakUBkBerD4KBsbej2qi9C+rzanKR3LXfoqxJtYHQs+Z8nQf1yz0IoF4
        gUPu0+lSbY3HqDbkyYVDcl4pTPTwe5BDzX/OqZlYLTyJfOhLFM2Evaaj0pt1IkDRXuOqgz6ozP5S1
        hzs6UHr7gbUGp1rYlHuZuVY3ZToMsEZGXXAbloMWE7AAkrXApMQRgThHgQ/4/0KwAfWHIzm9TR7FL
        9jtRn7rcnien1OoPCslLQjaJ9jV/FeoBx5XZpri29Wzv7ZI7LHLpvcyGH2JYqxkItM/QxPWSMwTbU
        bHJw5mNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qwFdy-00FdCR-0z;
        Fri, 27 Oct 2023 05:44:26 +0000
Date:   Thu, 26 Oct 2023 22:44:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] fanotify support for btrfs sub-volumes
Message-ID: <ZTtOOs4zZ1P/eDZn@infradead.org>
References: <20231025135048.36153-1-amir73il@gmail.com>
 <ZTk1ffCMDe9GrJjC@infradead.org>
 <20231025170445.qks7etxtwivyqz22@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025170445.qks7etxtwivyqz22@quack3>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 25, 2023 at 07:04:45PM +0200, Jan Kara wrote:
> Well, this is the discussion how btrfs should be presenting its subvolumes
> to VFS / userspace, isn't it?

Yes.  Which we've pressured to resolve forever, but it's been ignored.

> I never dived into that too closely but as
> far as I remember it was discussed to death without finding an acceptable
> (to all parties) solution? I guess having a different fsid per subvolume
> makes sense (and we can't change that given it is like that forever even if
> we wanted). Having different subvolumes share one superblock is more
> disputable but there were reasons for that as well. So I'm not sure how you
> imagine to resolve this...

We need to solve this out kernel wide, and right now the kernel doesn't
support different dev_t / fsids inside a single file syste at all.
SuSE hacks around that badly for limited user interfaces with the
horrible get_inode_dev method they've added, but this has been rejected
upstream for good reason.  What this series does is to add another
limited version of this through the backdoor.

