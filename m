Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7627 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412AbbBKA3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 19:29:10 -0500
Message-ID: <54DAA252.1090207@cn.fujitsu.com>
Date: Wed, 11 Feb 2015 08:29:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: fsck-test: Add check_sudo to check valid
 root/sudo privilege
References: <1423462312-4239-1-git-send-email-quwenruo@cn.fujitsu.com> <20150210133055.GA28877@twin.jikos.cz>
In-Reply-To: <20150210133055.GA28877@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: fsck-test: Add check_sudo to check 
valid root/sudo privilege
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年02月10日 21:30
> On Mon, Feb 09, 2015 at 02:11:52PM +0800, Qu Wenruo wrote:
>> Although fsck-test/012 uses sudo, it uses 'sudo -n', which won't prompt
>> user to input password and will return 1 if no valid credential is
>> found.
>>
>> And this makes test result quite annoying since it fails to mount and
>> still continue, which will always fail.
>>
>> This patch introduced the new check_sudo() to check sudo before calling
>> $sudo. This function will check "sudo -v -n" to get the credential.
>> And if it fails, then the test will not be run.
> This logic is fine, but the setup fails for me even if typing the
> password is not required. I think the 'sudo -v' check is wrong as it
> tries to refresh the credentials.
>
>    $ sudo -v -n
>    sudo: a password is required
>
> while
>
>    $ sudo -n /bin/true
>
> works.
Err, this seems strange.
I think the bug is in sudo itself.

BTW, what's the version of your sudo?
Mine works fine even no need for password:
$ sudo -v -n
No error....

My sudo version is 1.8.11p2

Thanks,
Qu

