Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2552 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbbCPFvO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 01:51:14 -0400
Message-ID: <55066E71.3000402@cn.fujitsu.com>
Date: Mon, 16 Mar 2015 13:47:29 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fstest: btrfs: add a test for quota number when deleting
 a subvol.
References: <54EEB798.1070105@cn.fujitsu.com> <1425381210-13661-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20150306050600.GQ16974@dhcp-13-216.nay.redhat.com> <550664EC.7090705@cn.fujitsu.com> <20150316053337.GA23302@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20150316053337.GA23302@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/16/2015 01:33 PM, Eryu Guan wrote:
> On Mon, Mar 16, 2015 at 01:06:52PM +0800, Dongsheng Yang wrote:
>> Hi Guan,  sorry for the late.
>>
>> On 03/06/2015 01:06 PM, Eryu Guan wrote:
>>> On Tue, Mar 03, 2015 at 07:13:30PM +0800, Dongsheng Yang wrote:
>>>> This regression is introduced by two commits:
>>>>
>>>> e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
>>>> 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)
> [snip]
>
>>>> +_cleanup()
>>>> +{
>>>> +    cd /
>>>> +    rm -f $tmp.*
>>> Better to use a tab not 4 spaces, maybe "new" should be updated too (in
>>> another patch)
>> Thanx, will send another patch for "./new".
> Just FYI, I've already sent out the fix, please see
>
> http://www.spinics.net/lists/fstests/msg01073.html
Great!! Thanx for your information. But I found some other 4 spaces in 
new, I am not sure
whether we also need to replace them with tab or not as shown below.

Thanx

commit 931340c0c5599ae2c6714df16c796ea24240a5a7
Author: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Date:   Mon Mar 16 01:15:53 2015 -0400

     new: replace 4 spaces with a tab.

     Sugguested-by: Eryu Guan <eguan@redhat.com>
     Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

diff --git a/new b/new
index 86f9075..f94daed 100755
--- a/new
+++ b/new
@@ -29,15 +29,15 @@ trap "rm -f /tmp/$$.; exit" 0 1 2 3 15

  _cleanup()
  {
-    :
+       :
  }

  SRC_GROUPS=`find tests -not -path tests -type d -printf "%f "`
  usage()
  {
-    echo "Usage $0 test_dir"
-    echo "Available dirs are: $SRC_GROUPS"
-    exit
+       echo "Usage $0 test_dir"
+       echo "Available dirs are: $SRC_GROUPS"
+       exit
  }

  [ $# -eq 0 ] && usage
@@ -46,8 +46,8 @@ shift

  if [ ! -f $tdir/group ]
  then
-    echo "Creating the $tdir/group index ..."
-    cat <<'End-of-File' >$tdir/group
+       echo "Creating the $tdir/group index ..."
+       cat <<'End-of-File' >$tdir/group
  # QA groups control
  #
  # define groups and default group owners
@@ -65,15 +65,15 @@ fi

  if [ ! -w $tdir/group ]
  then
-    chmod u+w $tdir/group
-    echo "Warning: making the index file \"$tdir/group\" writeable"
+       chmod u+w $tdir/group
+       echo "Warning: making the index file \"$tdir/group\" writeable"
  fi

  if make
  then
-    :
+       :
  else
-    echo "Warning: make failed -- some tests may be missing"
+       echo "Warning: make failed -- some tests may be missing"
  fi

  i=0
@@ -83,16 +83,16 @@ eof=1

  for found in `cat $tdir/group | $AWK_PROG '{ print $1 }'`
  do
-    line=$((line+1))
-    if [ -z "$found" ] || [ "$found" == "#" ];then
+       line=$((line+1))
+       if [ -z "$found" ] || [ "$found" == "#" ];then
         continue
-    fi
-    i=$((i+1))
-    id=`printf "%03d" $i`
-    if [ "$id" != "$found" ];then
+       fi
+       i=$((i+1))
+       id=`printf "%03d" $i`
+       if [ "$id" != "$found" ];then
         eof=0
         break
-    fi
+       fi
  done
  if [ $eof -eq 1 ]; then
     line=$((line+1))
@@ -104,9 +104,9 @@ echo "Next test is $id"

  if [ -f $tdir/$id ]
  then
-    echo "Error: test $id already exists!"
-    _cleanup
-    exit 1
+       echo "Error: test $id already exists!"
+       _cleanup
+       exit 1
  fi

  echo -n "Creating skeletal script for you to edit ..."
@@ -148,8 +148,8 @@ trap "_cleanup; exit \\\$status" 0 1 2 3 15

  _cleanup()
  {
-    cd /
-    rm -f \$tmp.*
+       cd /
+       rm -f \$tmp.*
  }

  # get standard environment, filters and checks
@@ -184,39 +184,39 @@ ${EDITOR-vi} $tdir/$id
  if [ $# -eq 0 ]
  then

-    while true
-    do
+       while true
+       do
         echo -n "Add to group(s) [other] (? for list): "
         read ans
         [ -z "$ans" ] && ans=other
         if [ "X$ans" = "X?" ]
         then
-           for d in $SRC_GROUPS; do
+               for d in $SRC_GROUPS; do
                 l=$(sed -n < tests/$d/group \
-                   -e 's/#.*//' \
-                   -e 's/$/ /' \
-                   -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
+                       -e 's/#.*//' \
+                       -e 's/$/ /' \
+                       -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
                 grpl="$grpl $l"
-           done
-           lst=`for word in $grpl; do echo $word; done | sort| uniq `
-           echo $lst
+               done
+               lst=`for word in $grpl; do echo $word; done | sort| uniq `
+               echo $lst
         else
-           break
+               break
         fi
-    done
+       done
  else
-    # expert mode, groups are on the command line
-    #
-    for g in $*
-    do
+       # expert mode, groups are on the command line
+       #
+       for g in $*
+       do
         if grep "^$g[   ]" $tdir/group >/dev/null
         then
-           :
+               :
         else
-           echo "Warning: group \"$g\" not defined in $tdir/group"
+               echo "Warning: group \"$g\" not defined in $tdir/group"
         fi
-    done
-    ans="$*"
+       done
+       ans="$*"
  fi

>
> Thanks,
> Eryu Guan
> .
>

