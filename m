From: Josef Bacik <josef@redhat.com>
Subject: Re: 2.6.39-rc1: btrfs "WARNING: at fs/btrfs/inode.c:2177"
Date: Thu, 07 Apr 2011 12:20:15 -0400
Message-ID: <4D9DE43F.3000809@redhat.com>
References: <1302169286.1922.19.camel@cephhost>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040507060007050700090606"
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
To: cpwu@tnsoft.com.cn
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1302169286.1922.19.camel@cephhost>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040507060007050700090606
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/07/2011 05:41 AM, Jeff Wu wrote:
> Hi ,
> I run iozone stress test on a ceph client for x86_64, ceph 0.26 +
> linux-2.6.39-rc1 server,
> printk "WARNING: at fs/btrfs/inode.c:2177"
>
Crap I was hoping I had fixed this, could you run with this debug patch 
and get me the output so I can figure out what's going on?  Thanks,

Josef



--------------040507060007050700090606
Content-Type: text/plain;
 name="debug.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="debug.patch"

ZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2V4dGVudC10cmVlLmMgYi9mcy9idHJmcy9leHRlbnQt
dHJlZS5jCmluZGV4IGY2MTljM2MuLjc5ZWM5MzMgMTAwNjQ0Ci0tLSBhL2ZzL2J0cmZzL2V4
dGVudC10cmVlLmMKKysrIGIvZnMvYnRyZnMvZXh0ZW50LXRyZWUuYwpAQCAtMzY5Niw2ICsz
Njk2LDcgQEAgaW50IGJ0cmZzX2Jsb2NrX3Jzdl9hZGQoc3RydWN0IGJ0cmZzX3RyYW5zX2hh
bmRsZSAqdHJhbnMsCiB7CiAJaW50IHJldDsKIAorCVdBUk5fT04oYmxvY2tfcnN2ID09IHJv
b3QtPm9ycGhhbl9ibG9ja19yc3YpOwogCWlmIChudW1fYnl0ZXMgPT0gMCkKIAkJcmV0dXJu
IDA7CiAK
--------------040507060007050700090606--
