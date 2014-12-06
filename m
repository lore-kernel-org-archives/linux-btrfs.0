Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:54107 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLFCfX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 21:35:23 -0500
Date: Sat, 6 Dec 2014 02:35:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: General Question: ctime, mtime, and xattrs
Message-ID: <20141206023517.GA22149@ZenIV.linux.org.uk>
References: <54822CEE.5070603@pobox.com>
 <CAE5mzvgrdYSNWSWLrnmHMz2fSgPSJV_ocYr_ZSBGPwLWBshH-g@mail.gmail.com>
 <54823FBA.9000707@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54823FBA.9000707@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 05, 2014 at 03:28:58PM -0800, Robert White wrote:
> Ah...
> 
> I've been thinking "ctime" is/was (still) "create time". It seems
> that somewhere in the last couple decades it became "change time";
> Or that I picked up that incorrect "create time" idea back in the
> UNIX Sys V R 3 days and just never had cause to think about it
> again...

v7 is the point where the third timestamp has first appeared (v6 has
only two - access and update).  And their stat(2) says this:
       st_atime is the file was last read.  For reasons of efficiency,  it  is
       not set when a directory is searched, although this would be more logi‐
       cal.  st_mtime is the time the file was last written or created.  It is
       not  set  by changes of owner, group, link count, or mode.  st_ctime is
       set both both by writing and changing the i-node.

FWIW, their /usr/sys/sys/sys4.c has
chmod()
{
        register struct inode *ip;
        register struct a {
                char    *fname;
                int     fmode;
        } *uap;

        uap = (struct a *)u.u_ap;
        if ((ip = owner()) == NULL)
                return;
        ip->i_mode &= ~07777;
        if (u.u_uid)
                uap->fmode &= ~ISVTX;
        ip->i_mode |= uap->fmode&07777;
        ip->i_flag |= ICHG;
        if (ip->i_flag&ITEXT && (ip->i_mode&ISVTX)==0)
                xrele(ip);
        iput(ip);
}
and /usr/sys/sys/iget.c has, in the end of iupdat() (called on the final
iput(), as well as on stat(2) and several other paths), this:
                if(ip->i_flag&IACC)
                        dp->di_atime = *ta;
                if(ip->i_flag&IUPD)
                        dp->di_mtime = *tm;
                if(ip->i_flag&ICHG)
                        dp->di_ctime = time;
                ip->i_flag &= ~(IUPD|IACC|ICHG);
(ta and tm are both equal to &time in that call chain).  IOW, chmod(2)
definitely sets ctime.

IOW, ctime has never been "create time"; it's "change time" and it had been
that way since its introduction.
