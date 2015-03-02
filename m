Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47191 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbbCBAnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Mar 2015 19:43:08 -0500
Message-ID: <54F3B21A.8080602@cn.fujitsu.com>
Date: Mon, 2 Mar 2015 08:43:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: fsck-test: Add check_sudo to check valid
 root/sudo privilege
References: <1423462312-4239-1-git-send-email-quwenruo@cn.fujitsu.com> <20150210133055.GA28877@twin.jikos.cz> <54DAA252.1090207@cn.fujitsu.com> <20150227161144.GE8720@twin.jikos.cz>
In-Reply-To: <20150227161144.GE8720@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Wed, Feb 11, 2015 at 08:29:06AM +0800, Qu Wenruo wrote:
>>
>> -------- Original Message --------
>> Subject: Re: [PATCH] btrfs-progs: fsck-test: Add check_sudo to check
>> valid root/sudo privilege
>> From: David Sterba <dsterba@suse.cz>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date: 2015年02月10日 21:30
>>> On Mon, Feb 09, 2015 at 02:11:52PM +0800, Qu Wenruo wrote:
>>>> Although fsck-test/012 uses sudo, it uses 'sudo -n', which won't prompt
>>>> user to input password and will return 1 if no valid credential is
>>>> found.
>>>>
>>>> And this makes test result quite annoying since it fails to mount and
>>>> still continue, which will always fail.
>>>>
>>>> This patch introduced the new check_sudo() to check sudo before calling
>>>> $sudo. This function will check "sudo -v -n" to get the credential.
>>>> And if it fails, then the test will not be run.
>>> This logic is fine, but the setup fails for me even if typing the
>>> password is not required. I think the 'sudo -v' check is wrong as it
>>> tries to refresh the credentials.
>>>
>>>     $ sudo -v -n
>>>     sudo: a password is required
>>>
>>> while
>>>
>>>     $ sudo -n /bin/true
>>>
>>> works.
>> Err, this seems strange.
>> I think the bug is in sudo itself.
>
> Or the the way sudo is configured in /etc/sudoers.
>
>> BTW, what's the version of your sudo?
>> Mine works fine even no need for password:
>> $ sudo -v -n
>> No error....
>>
>> My sudo version is 1.8.11p2
>
> 1.8.10p3
>
> I don't know how to fix it so it works for both of us.
>
Hmm, what about using the following priority to setup sudo in 
setup_root_helper()?

UID==0
"sudo -v -n" if it works << For newer sudo
"sudo -n" if it works << For your version or older

Thanks,
Qu
