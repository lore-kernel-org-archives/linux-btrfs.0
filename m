Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbaE0RVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 13:21:00 -0400
Message-ID: <5384C978.10807@suse.com>
Date: Tue, 27 May 2014 13:20:56 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4] btrfs: allocate raid type kobjects dynamically
References: <5384C48D.7040707@suse.com> <5384C68C.507@fb.com> <5384C9D9.9000705@fb.com>
In-Reply-To: <5384C9D9.9000705@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/27/14, 1:22 PM, Chris Mason wrote:
> 
> 
> On 05/27/2014 01:08 PM, Chris Mason wrote:
>> On 05/27/2014 12:59 PM, Jeff Mahoney wrote:
>>> We are currently allocating space_info objects in an array when
>>> we allocate space_info. When a user does something like:
>>> 
>>> # btrfs balance start -mconvert=raid1 -dconvert=raid1 /mnt #
>>> btrfs balance start -mconvert=single -dconvert=single /mnt -f #
>>> btrfs balance start -mconvert=raid1 -dconvert=raid1 /
>>> 
>>> We can end up with memory corruption since the kobject hasn't 
>>> been reinitialized properly and the name pointer was left set.
>>> 
>>> The rationale behind allocating them statically was to avoid 
>>> creating a separate kobject container that just contained the 
>>> raid type. It used the index in the array to determine the
>>> index.
>>> 
>>> Ultimately, though, this wastes more memory than it saves in
>>> all but the most complex scenarios and introduces kobject
>>> lifetime questions.
>>> 
>>> This patch allocates the kobjects dynamically instead. Note
>>> that we also remove the kobject_get/put of the parent kobject
>>> since kobject_add and kobject_del do that internally.
>>> 
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> 
>> Lets see how smart patchwork is:
>> 
>> Reported-by:David Sterba <dsterba@suse.cz>
> 
> For future reference, not that smart.

Have you already added it or should I just post it again with the rb?

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJThMl4AAoJEB57S2MheeWywE0QAI07WMgArtqHqIxpQcZIOS6V
1tIIflZB3FSLOxtrfTHbGAAMcfUueuz+wJvkaj/qKpcZ4ONVn3yeBpmYvH8FleAd
V7SjGvp+ZiUKZVk0PR2bPUdKABcqaVntHs7fs4YZ0ivyBz7XsOtLv5WmuF+CFZb5
QFq5oGAwnMPmxY42O65gn6dK+c+IbkfkLlVNFqg0hKFfhraNF8eCnW2wf3jt2/gl
92ktasmfiD/6f87dijo51o2AkVWBv7UsiFnK95HJ3u5CSXsoQ6SdCQCY4vfUuvBS
S0WiKM2qp3l3ZMZ63EVxdNQ0Nv95DTJhQalES0wYPZDy65O11MqFRSV+08Nw0KG5
9ZaPM4EZzbQmyowzzb+ck91GHJ25WNt50RQsUMrFuMXlMEQR0o9gN4F1asAB6VJL
G/67B50NXgUBXAqHg9did70t9ipYZIWwsF/UBAtmeachIwq9AUnD4FCA9vu3Qe2q
y/C86hT3GgTcBvehuOZO3GZZeIC1YuW1jTWwtNan0RfPlvtcs0djIF3h2cXiYyCF
DqdV41aT7+vwT2QSSEDflPfI5uhJUbFezlwANFKX7ecC6ZkfCCLUzZj8YiqD5tN2
kQtSR9uPNPpWhB8xOwchlTQH8CZAUOM/+LpguQsh6DbFgb3Yi2A2lO7sfcMpFjcA
H11fIBAYlsUy6ZSd+S0B
=8PGQ
-----END PGP SIGNATURE-----
