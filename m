Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54097 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2IYCry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 22:47:54 -0400
Received: by qcro28 with SMTP id o28so4905274qcr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 19:47:53 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Sep 2012 10:47:53 +0800
Message-ID: <CAPgLHd9cc_fO5KAjCLKquzvpkZJGy_UGA859y=nrA2NYrt9CrA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix return value check in btrfs_ioctl_send()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris.mason@fusionio.com, yongjun_wei@trendmicro.com.cn,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/24/2012 10:03 PM, David Sterba wrote:
> On Mon, Sep 24, 2012 at 09:40:00PM +0800, Wei Yongjun wrote:
>>>> dpatch engine is used to auto generated this patch.
>>>> (https://github.com/weiyj/dpatch)
>>> I've played with it, looks nice, although it's full of hardcoded paths.
>> Yes, it is current hardcoded path, because I used the linux.git and
>> linux-next.git, and dpatch will update the git tree every day.
>> After login, you can change the git url in the web.
> Sure, I was able to point the git source to my local linux.git.
>
>>> I'd like to run it directly from the git repo. Can you please fix that?
>>> No patch from me, because I hadcoded my paths :)
>> Do you mean does not need auto update git repo, only scan the
>> change under your git repo?
> I'm talking about hardcoded paths for the scripts in bin/ like
>
> dpatch/views/engine.py:
> args = '/usr/dpatch/bin/importcocci.sh %s' % fname
>
> or dpatch/models.py:
> return '/var/lib/dpatch/repo/' + dname
>
> Not to say that '/usr/' is not the right place for adding new
> per-package subdirs, refer to
> http://www.pathname.com/fhs/pub/fhs-2.3.html#THEUSRHIERARCHY

I have fix the hardcode path issue, and allow dpatch
to be run without installation.

> .
>
> (Also the database has hardcoded path into /var/lib/dpatch)
>
>>> It would be great if we can run a set of .cocci scripts that would
>>> verify code invariants (limited to cocci capabilities, but eg. the
>>> IS_ERR is a good example) and add new ones eventually over time.
>> By default, It does not include cocci scripts, only include dup include,
>> useless 'linux/version.h' check engine, and is disabled.
> No problem that the .cocci scripts are not there, I'm fine with adding
> them manually now, just to test the tool, but all the hardcoded paths
> didn't let me do that :)

I have put a sample cocci script to pattern/cocci dir, and we can
import other cocci file using command:

./bin/importcocci.sh /path/to/file.cocci

and then enable it vi the web ui.

the import file have special format:

/// title for patch
///
/// patch description
///
cocci script content
...

and then your can manual scan using the following command:

$ ./bin/dailypatch.sh      patch scan + build test

or
$./bin/dailyupdate.sh     patch scan

or
$ ./bin/dailybuild.sh    build test


The database is adminstrator is admin, passwd: 111111

Regards,
Yongjun Wei

