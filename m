Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:11785 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbcLGFlV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 00:41:21 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 05A02AC017B
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Dec 2016 14:41:14 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: qgroup: add sync option to 'qgroup show'
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
 <4574d8b0-fa15-cca0-dd93-9e207f21e4a7@cn.fujitsu.com>
 <8c47a865-717a-262b-f116-a44449c8aada@jp.fujitsu.com>
 <b5aa024e-54ef-53ec-33e6-46f881c6a2f6@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <38719b08-fc29-86a6-cd5b-73f066b074dc@jp.fujitsu.com>
Date: Wed, 7 Dec 2016 14:41:04 +0900
MIME-Version: 1.0
In-Reply-To: <b5aa024e-54ef-53ec-33e6-46f881c6a2f6@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/12/07 13:59, Qu Wenruo wrote:
> 
> 
> At 12/07/2016 12:31 PM, Tsutomu Itoh wrote:
>> Hi Qu,
>>
>> Thanks for the review.
>>
>> On 2016/12/07 12:24, Qu Wenruo wrote:
>>>
>>>
>>> At 12/07/2016 11:07 AM, Tsutomu Itoh wrote:
>>>> The 'qgroup show' command does not synchronize filesystem.
>>>> Therefore, 'qgroup show' may not display the correct value unless
>>>> synchronized with 'filesystem sync' command etc.
>>>>
>>>> So add the '--sync' and '--no-sync' options so that we can choose
>>>> whether or not to synchronize when executing the command.
>>>
>>> Indeed, --sync would help in a lot of cases.
>>>
>>>>
>>>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>>>> ---
>>>>  Documentation/btrfs-qgroup.asciidoc |  5 +++++
>>>>  cmds-qgroup.c                       | 24 ++++++++++++++++++++++--
>>>>  2 files changed, 27 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
>>>> index 438dbc7..dd133ec 100644
>>>> --- a/Documentation/btrfs-qgroup.asciidoc
>>>> +++ b/Documentation/btrfs-qgroup.asciidoc
>>>> @@ -126,6 +126,11 @@ Prefix \'+' means ascending order and \'-' means descending order of <attr>.
>>>>  If no prefix is given, use ascending order by default.
>>>>  +
>>>>  If multiple <attr>s is given, use comma to separate.
>>>> ++
>>>> +--sync::::
>>>> +invoke sync before getting info.
>>>
>>> A little more words would help, to info user that qgroup will only update after sync.
>>>
>>>> +--no-sync::::
>>>> +do not invoke sync before getting info (default).
>>>>
>>>>  EXIT STATUS
>>>>  -----------
>>>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>>>> index bc15077..ac339f3 100644
>>>> --- a/cmds-qgroup.c
>>>> +++ b/cmds-qgroup.c
>>>> @@ -272,8 +272,7 @@ static int cmd_qgroup_destroy(int argc, char **argv)
>>>>  }
>>>>
>>>>  static const char * const cmd_qgroup_show_usage[] = {
>>>> -    "btrfs qgroup show -pcreFf "
>>>> -    "[--sort=qgroupid,rfer,excl,max_rfer,max_excl] <path>",
>>>> +    "btrfs qgroup show [options] <path>",
>>>>      "Show subvolume quota groups.",
>>>>      "-p             print parent qgroup id",
>>>>      "-c             print child qgroup id",
>>>> @@ -288,6 +287,8 @@ static const char * const cmd_qgroup_show_usage[] = {
>>>>      "               list qgroups sorted by specified items",
>>>>      "               you can use '+' or '-' in front of each item.",
>>>>      "               (+:ascending, -:descending, ascending default)",
>>>> +    "--sync         invoke sync before getting info",
>>>> +    "--no-sync      do not invoke sync before getting info (default)",
>>>
>>> I see you're using -Y and -N option, it's better also to show
>>> the short option together, if we will use that short option.
>>
>> Do you think that a short option is necessary?
>> I thought it was not necessary...
> 
> Just mean if we use short option in getopt, it's better to mention it in both man page and help string.
> 
>>
>>>
>>>>      NULL
>>>>  };
>>>>
>>>> @@ -301,6 +302,7 @@ static int cmd_qgroup_show(int argc, char **argv)
>>>>      u64 qgroupid;
>>>>      int filter_flag = 0;
>>>>      unsigned unit_mode;
>>>> +    int sync = 0;
>>>>
>>>>      struct btrfs_qgroup_comparer_set *comparer_set;
>>>>      struct btrfs_qgroup_filter_set *filter_set;
>>>> @@ -313,6 +315,8 @@ static int cmd_qgroup_show(int argc, char **argv)
>>>>          int c;
>>>>          static const struct option long_options[] = {
>>>>              {"sort", required_argument, NULL, 'S'},
>>>> +            {"sync", no_argument, NULL, 'Y'},
>>>> +            {"no-sync", no_argument, NULL, 'N'},
>>>
>>> Although I'm not sure if "-Y" and "-N" is proper here.
>>> IMHO, it's more like something to say all "Yes" or "No" to any interactive confirmation.
>>>
>>> Maybe non-charactor option will be better.
>>
>> Umm, these mean s(Y)nc/(N)osync, and the user can not specify short options...
>> Still would you rather change to another character?
> 
> If not using short option, it's better to use non-character value instead of 'Y' and 'N'.
> 
> Use any number larger than 256 would do the trick, just like we did in qgroup assign:
> 
> enum { GETOPT_VAL_RESCAN = 256, GETOPT_VAL_NO_RESCAN };
> static const struct option long_options[] = {
>         { "rescan", no_argument, NULL, GETOPT_VAL_RESCAN },
>         { "no-rescan", no_argument, NULL, GETOPT_VAL_NO_RESCAN },
>         { NULL, 0, NULL, 0 }
> };
> int c = getopt_long(argc, argv, "", long_options, NULL);
> 
> BTW, I'm completely OK not to use short option.
> Just the "Y" and "N" a little confusing to me since they are not mentioned anywhere.

OK, thanks. I'll post v2 patch soon.

Thanks,
Tsutomu

> 
> Thanks,
> Qu
>>
>> Thanks,
>> Tsutomu
>>
>>>
>>> Other part looks good to me.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>              { NULL, 0, NULL, 0 }
>>>>          };
>>>>
>>>> @@ -348,6 +352,12 @@ static int cmd_qgroup_show(int argc, char **argv)
>>>>              if (ret)
>>>>                  usage(cmd_qgroup_show_usage);
>>>>              break;
>>>> +        case 'Y':
>>>> +            sync = 1;
>>>> +            break;
>>>> +        case 'N':
>>>> +            sync = 0;
>>>> +            break;
>>>>          default:
>>>>              usage(cmd_qgroup_show_usage);
>>>>          }
>>>> @@ -365,6 +375,16 @@ static int cmd_qgroup_show(int argc, char **argv)
>>>>          return 1;
>>>>      }
>>>>
>>>> +    if (sync) {
>>>> +        ret = ioctl(fd, BTRFS_IOC_SYNC);
>>>> +        if (ret < 0) {
>>>> +            error("sync ioctl failed on '%s': %s", path,
>>>> +                  strerror(errno));
>>>> +            close_file_or_dir(fd, dirstream);
>>>> +            goto out;
>>>> +        }
>>>> +    }
>>>> +
>>>>      if (filter_flag) {
>>>>          ret = lookup_path_rootid(fd, &qgroupid);
>>>>          if (ret < 0) {
>>>>
>>>
>>>


