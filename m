Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA45C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 22:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68C67217F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 22:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1P3Rcxiy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbfC2WfB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 18:35:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55244 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730240AbfC2WfB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 18:35:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2TMYRDn032256;
        Fri, 29 Mar 2019 22:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=EaTqNe2Q42rMNhwrqhpOliAvhxclg5JD4iXBknuQdwU=;
 b=1P3RcxiyO72KyNmwrNLywDCUcy3/27liykVCQ1XbnlZgTHTJB7pcqto6HEhi2MiSjYMH
 CGS9c6I9m6B886BBUZ/X21BGkchmLxPIGNUIyo0r2tv1spYIgDijq2zAWTVhLP9OUo0F
 OM3k3SsMvaAPzAKqc5Mot6s2UWjwFRXHRUIMcedJWTbD1ndyf307PKy8o/nfjvLQXTot
 1WC2iioDzGXcqMx34zslkFRzQZspG/XaZwuaLEys+qIUu+c61i5iqd/aPzjzMo+GeFZS
 JVjYVrqfoVP8mHKXH3pnUUSGQ9KoUZPGA/CZgrDPiKPnz31WqEBUUjl4gYBX2spe8XfE 8Q== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2re6g1f09a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Mar 2019 22:34:54 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2TMYrgb030100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Mar 2019 22:34:53 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2TMYrmK031634;
        Fri, 29 Mar 2019 22:34:53 GMT
Received: from localhost (/98.248.117.137)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Mar 2019 15:34:52 -0700
Date:   Fri, 29 Mar 2019 15:34:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 2/7] fsstress: add operation for setting xattrs on files
 and directories
Message-ID: <20190329223451.GF6537@magnolia>
References: <20190328185404.28879-1-fdmanana@kernel.org>
 <20190328214839.GM26298@dastard>
 <CAL3q7H6uHcsEvBCTaBaTeCPhsQ2XHDRqVu7tVa-bPc9iHP6pNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6uHcsEvBCTaBaTeCPhsQ2XHDRqVu7tVa-bPc9iHP6pNw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9211 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903290153
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 10:36:37PM +0000, Filipe Manana wrote:
> On Thu, Mar 28, 2019 at 9:48 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Mar 28, 2019 at 06:54:04PM +0000, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Currently fsstress does not exercise creating, reading or deleting xattrs
> > > on files or directories. This change adds support for setting xattrs on
> > > files and directories, using only the xattr user namespace (the other
> > > namespaces are not general purpose and are used for security, capabilities,
> > > ACLs, etc). This adds a counter for each file entry structure that keeps
> > > track of the number of xattrs set for the file entry, and each new xattr
> > > has a name that includes the counter's value (example: "user.x4").
> > > Values for the xattrs have at most 100 bytes, which is much more than
> > > the maximum size supported for all major filesystems.
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >  ltp/fsstress.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 141 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > index cc4f520e..03e40eb6 100644
> > > --- a/ltp/fsstress.c
> > > +++ b/ltp/fsstress.c
> > > @@ -27,6 +27,7 @@
> > >  io_context_t io_ctx;
> > >  #endif
> > >  #include <sys/syscall.h>
> > > +#include <sys/xattr.h>
> > >
> > >  #ifndef FS_IOC_GETFLAGS
> > >  #define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
> > > @@ -85,6 +86,7 @@ typedef enum {
> > >       OP_RESVSP,
> > >       OP_RMDIR,
> > >       OP_SETATTR,
> > > +     OP_SETXATTR,
> > >       OP_SPLICE,
> > >       OP_STAT,
> > >       OP_SYMLINK,
> > > @@ -110,6 +112,7 @@ typedef struct opdesc {
> > >  typedef struct fent {
> > >       int     id;
> > >       int     parent;
> > > +     int     xattr_counter;
> > >  } fent_t;
> > >
> > >  typedef struct flist {
> > > @@ -195,6 +198,7 @@ void      rename_f(int, long);
> > >  void resvsp_f(int, long);
> > >  void rmdir_f(int, long);
> > >  void setattr_f(int, long);
> > > +void setxattr_f(int, long);
> > >  void splice_f(int, long);
> > >  void stat_f(int, long);
> > >  void symlink_f(int, long);
> > > @@ -246,6 +250,7 @@ opdesc_t  ops[] = {
> > >       { OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
> > >       { OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
> > >       { OP_SETATTR, "setattr", setattr_f, 0, 1 },
> > > +     { OP_SETXATTR, "setxattr", setxattr_f, 4, 1 },
> >
> > Ok, now that I see this, the penny drops - you can't do this as
> > it changes the CLI interface in a way that will make existing
> > scripts do something entirely different to what they used to do.
> >
> > i.e. "-f setxattr=n" is used to specify the frequency of this
> > specific operation. It used to control the project ID setting, now
> > with this change it controls extended attribute frequency. There are
> > some tests that actually use "-f setxattr=n" (and who knows how many
> > custom test scripts using fsstress built from fstests), so I don't
> > think we should be renaming existing operations to something else
> > and then reusing the name for a new type of operation like this....
> 
> Any idea for a good name? (Not too long, or too similar like setextattr)

setfattr, seeing as it's a cli tool already anyway?

--D

> 
> 
> >
> > I certainly agree with the idea of adding extended attributes to
> > fsstress, just not this way...
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
