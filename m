Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:39203 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1425353AbdD1Syh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 14:54:37 -0400
Reply-To: kreijack@inwind.it
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
 <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
 <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <2bfe32ee-4db6-f3ca-ce87-ec72ce300bd0@inwind.it>
Date: Fri, 28 Apr 2017 20:54:33 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-28 19:41, Chris Murphy wrote:
> On Fri, Apr 28, 2017 at 11:05 AM, Goffredo Baroncelli
> <kreijack@inwind.it> wrote:
> 
>> In the past I faced the same problems; I collected some data here http://kreijack.blogspot.it/2014/06/btrfs-and-systemd-journal.html.
>> Unfortunately the journald files are very bad, because first the data is written (appended), then the index fields are updated. Unfortunately these indexes are near after the last write . So fragmentation is unavoidable.
>>
>> After some thinking I adopted a different strategies: I used journald as collector, then I forward all the log to rsyslogd, which used a "log append" format. Journald never write on the root filesystem, only in tmp.
> 
> The gotcha though is there's a pile of data in the journal that would
> never make it to rsyslogd. If you use journalctl -o verbose you can
> see some of this. 

You can send *all the info* to rsyslogd via imjournal

http://www.rsyslog.com/doc/v8-stable/configuration/modules/imjournal.html

In my setup all the data are stored in json format in the /var/log/cee.log file:


$ head  /var/log/cee.log
2017-04-28T18:41:41.931273+02:00 venice liblogging-stdlog: @cee: { "PRIORITY": "6", "_BOOT_ID": "a86d74bab91f44dc974c76aceb97141f", "_MACHINE_ID": "e84907d099904117b355a99c98378dca", "_HOSTNAME": "venice.bhome", "_SYSTEMD_SLICE": "system.slice", "_UID": "0", "_GID": "0", "_CAP_EFFECTIVE": "3fffffffff", "_TRANSPORT": "syslog", "SYSLOG_FACILITY": "23", "SYSLOG_IDENTIFIER": "liblogging-stdlog", "MESSAGE": " [origin software=\"rsyslogd\" swVersion=\"8.24.0\" x-pid=\"737\" x-info=\"http:\/\/www.rsyslog.com\"] rsyslogd was HUPed", "_PID": "737", "_COMM": "rsyslogd", "_EXE": "\/usr\/sbin\/rsyslogd", "_CMDLINE": "\/usr\/sbin\/rsyslogd -n", "_SYSTEMD_CGROUP": "\/system.slice\/rsyslog.service", "_SYSTEMD_UNIT": "rsyslog.service", "_SYSTEMD_INVOCATION_ID": "18b9a8b27f9143728adef972db7b394c", "_SOURCE_REALTIME_TIMESTAMP": "1493397701931255", "msg": "[origin software=\"rsyslogd\" swVersion=\"8.24.0\" x-pid=\"737\" x-info=\"http:\/\/www.rsyslog.com\"] rsyslogd was HUPed" }
2017-04-28T18:41:42.058549+02:00 venice liblogging-stdlog: @cee: { "PRIORITY": "6", "_BOOT_ID": "a86d74bab91f44dc974c76aceb97141f", "_MACHINE_ID": "e84907d099904117b355a99c98378dca", "_HOSTNAME": "venice.bhome", "_SYSTEMD_SLICE": "system.slice", "_UID": "0", "_GID": "0", "_CAP_EFFECTIVE": "3fffffffff", "_TRANSPORT": "syslog", "SYSLOG_FACILITY": "23", "SYSLOG_IDENTIFIER": "liblogging-stdlog", "MESSAGE": " [origin software=\"rsyslogd\" swVersion=\"8.24.0\" x-pid=\"737\" x-info=\"http:\/\/www.rsyslog.com\"] rsyslogd was HUPed", "_PID": "737", "_COMM": "rsyslogd", "_EXE": "\/usr\/sbin\/rsyslogd", "_CMDLINE": "\/usr\/sbin\/rsyslogd -n", "_SYSTEMD_CGROUP": "\/system.slice\/rsyslog.service", "_SYSTEMD_UNIT": "rsyslog.service", "_SYSTEMD_INVOCATION_ID": "18b9a8b27f9143728adef972db7b394c", "_SOURCE_REALTIME_TIMESTAMP": "1493397702058441", "msg": "[origin software=\"rsyslogd\" swVersion=\"8.24.0\" x-pid=\"737\" x-info=\"http:\/\/www.rsyslog.com\"] rsyslogd was HUPed" }
[....]

All the info are stored with the same keys/values as journald does.

I developed an utility (called clp), which allow to query the log by key, filtering by boot nr, by date....

For example to show all the log related to rsyslog

$ clp log -t full-details _SYSTEMD_CGROUP=/system.slice/rsyslog.service 

2017-04-21 19:12:29.579748 MESSAGE= [origin software="rsyslogd" swVersion="8.24.0" x-pid="804" x-info="http://www.rsyslog.com"] rsyslogd was HUPed
                           PRIORITY=6
                           SYSLOG_FACILITY=23
                           SYSLOG_IDENTIFIER=liblogging-stdlog
                           _BOOT_ID=d77198380c9344248e01166fbd8d60df
                           _CAP_EFFECTIVE=3fffffffff
                           _CMDLINE=/usr/sbin/rsyslogd -n
                           _COMM=rsyslogd
                           _EXE=/usr/sbin/rsyslogd
                           _GID=0
                           _HOSTNAME=venice.bhome
                           _LOGFILEINITLINE=2017-04-21T19:12:29.579768+02:00 venice liblogging-stdlog: 
                           _LOGFILELINENUMBER=1
                           _LOGFILENAME=/var/log/cee.log.7.gz
                           _LOGFILETIMESTAMP=1492794749579768
                           _MACHINE_ID=e84907d099904117b355a99c98378dca
                           _PID=804
                           _SOURCE_REALTIME_TIMESTAMP=1492794749579748
                           _SYSTEMD_CGROUP=/system.slice/rsyslog.service
                           _SYSTEMD_INVOCATION_ID=8f9cb6c871be4158a3ccb374f4323027
                           _SYSTEMD_SLICE=system.slice
                           _SYSTEMD_UNIT=rsyslog.service
                           _TRANSPORT=syslog
                           _UID=0
                           msg=[origin software="rsyslogd" swVersion="8.24.0" x-pid="804" x-info="http://www.rsyslog.com"] rsyslogd was HUPed

2017-04-21 19:12:29.669637 MESSAGE= [origin software="rsyslogd" swVersion="8.24.0" x-pid="804" x-info="http://www.rsyslog.com"] rsyslogd was HUPed
                           PRIORITY=6
                           SYSLOG_FACILITY=23
                           SYSLOG_IDENTIFIER=liblogging-stdlog
                           _BOOT_ID=d77198380c9344248e01166fbd8d60df
                           _CAP_EFFECTIVE=3fffffffff
                           _CMDLINE=/usr/sbin/r
[...]


> There's a bunch of extra metadata in the journal.
> And then also filtering based on that metadata is useful rather than
> being limited to grep on a syslog file. Which, you know, it's fine for
> many use cases. 

With imjournal you don't loose any metadata or data. Unfortunately there no is an utility to query the log. In my case I developed a my own

> I guess I'm just interested in whether there's an
> enhancement that can be done to make journals more compatible with
> Btrfs or vice versa. It's not a huge problem anyway.

I am still inclined to think that a text file format "append only" would be better than the pseudo database which journald uses. However I have to collect some data to be sure that the perfomance would not be worse. To do that I need some megabytes of log, which I don't have because I don't use the journald file format. Someone would share with me its logs :-) ?

> 
> 
>>
>> The think became interesting when I discovered that the searching in a rsyslog file is faster than journalctl (on a rotational media). Unfortunately I don't have any data to support this.
> 
> 
> Yes on drives all of these scattered extents cause a lot of head
> seeking. And I also suspect it's a lot of metadata spread out
> everywhere too, to account for all of these extents. That's why they
> moved to chattr +C to make them nocow. An idea I had on systemd list
> was to automatically make the journal directory a Btrfs subvolume,
> similar to how systemd already creates a /var/lib/machines subvolume
> for nspawn containers. This prevents the journals from being caught up
> in a snapshot of the parent subvolume that typically contains the
> journals (root fs). There's no practical use I can think of for
> snapshotting logs. You'd really want the logs to always be linear,
> contiguous, and never get rolled back. Even if something in the system
> does get rolled back, you'd want the logs to show that and continue
> on, rather than being rolled back themselves.
> 
> So the super simple option would be continue with +C on journals, and
> then a separate subvolume to prevent COW from ever happening
> inadvertently.
> 
> The same behavior happens with NTFS in qcow2 files. They quickly end
> up with 100,000+ extents unless set nocow. It's like the worst case
> scenario.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
