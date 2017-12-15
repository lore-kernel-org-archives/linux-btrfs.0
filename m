Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:38691 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753852AbdLOIWQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:22:16 -0500
Date: Fri, 15 Dec 2017 09:22:14 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171215082214.GA13892@polanet.pl>
References: <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
 <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
 <20171210112738.GA24090@polanet.pl>
 <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
 <20171211114043.GA5097@polanet.pl>
 <7ea3ab01-eb63-4875-7496-a4ad833c5854@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <7ea3ab01-eb63-4875-7496-a4ad833c5854@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 12, 2017 at 08:50:15 +0800, Qu Wenruo wrote:

> Even without snapshot, things can easily go crazy.
> 
> This will write 128M file (max btrfs file extent size) and write it to disk.
> # xfs_io -f -c "pwrite 0 128M" -c "sync" /mnt/btrfs/file
> 
> Then, overwrite the 1~128M range.
> # xfs_io -f -c "pwrite 1M 127M" -c "sync" /mnt/btrfs/file
> 
> Guess your real disk usage, it's 127M + 128M = 255M.
> 
> The point here, if there is any reference of a file extent, the whole
> extent won't be freed, even it's only 1M of a 128M extent.

OK, /this/ is scary. I guess nocow prevents this behaviour?
I have +C chatted the file eating my space and it ceased.

> Are you pre-allocating the file before write using tools like dd?

I have no idea, this could be checked in source of http://pam-abl.sourceforge.net/
But this is plain Berkeley DB (5.3 in my case)... which scarries me even
more:

$  rpm -q --what-requires 'libdb-5.2.so()(64bit)' 'libdb-5.3.so()(64bit)' | wc -l
14

#  ipoldek desc -B db5.3
Package:        db5.3-5.3.28.0-4.x86_64
Required(by):   apache1-base, apache1-mod_ssl, apr-util-dbm-db,
bogofilter, 
    c-icap, c-icap-srv_url_check, courier-authlib, 
    courier-authlib-authuserdb, courier-imap, courier-imap-common, 
    cyrus-imapd, cyrus-imapd-libs, cyrus-sasl, cyrus-sasl-sasldb, 
    db5.3-devel, db5.3-utils, dnshistory, dsniff, evolution-data-server, 
    evolution-data-server-libs, exim, gda-db, ggz-server, 
    heimdal-libs-common, hotkeys, inn, inn-libs, isync, jabberd, jigdo, 
    jigdo-gtk, jnettop, libetpan, libgda3, libgda3-devel, libhome, libqxt, 
    libsolv, lizardfs-master, maildrop, moc, mutt, netatalk, nss_updatedb, 
    ocaml-dbm, opensips, opensmtpd, pam-pam_abl, pam-pam_ccreds, perl-BDB, 
    perl-BerkeleyDB, perl-BerkeleyDB, perl-DB_File, perl-URPM, 
    perl-cyrus-imapd, php4-dba, php52-dba, php53-dba, php54-dba, php55-dba, 
    php56-dba, php70-dba, php70-dba, php71-dba, php71-dba, php72-dba, 
    php72-dba, postfix, python-bsddb, python-modules, python3-bsddb3, 
    redland, ruby-modules, sendmail, squid-session_acl, 
    squid-time_quota_acl, squidGuard, subversion-libs, swish-e, tomoe-svn, 
    webalizer-base, wwwcount

OK, not much of user-applications here, as they mostly use sqlite.
I wonder how this one db-library behaves:

$  find . -name \*.sqlite | xargs ls -gGhS | head -n1
-rw-r--r-- 1  15M 2017-12-08 12:14 ./.mozilla/firefox/vni9ojqi.default/extension-data/ublock0.sqlite

$  ~/fiemap ./.mozilla/firefox/*.default/extension-data/ublock0.sqlite | head -n1
File ./.mozilla/firefox/vni9ojqi.default/extension-data/ublock0.sqlite has 128 extents:


At least every $HOME/{.{,c}cache,tmp} should be +C...

> And if possible, use nocow for this file.

Actually, this should be officially advised to use +C for entire /var tree and
every other tree that might be exposed for hostile write patterns, like /home
or /tmp (if held on btrfs).

I'd say, that from security point of view the nocow should be default,
unless specified for mount or specific file... Currently, if I mount
with nocow, there is no way to whitelist trusted users or secure
location, and until btrfs-specific options could be handled per
subvolume, there is really no alternative.


-- 
Tomasz Pala <gotar@pld-linux.org>
